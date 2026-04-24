# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A NixOS flake-based personal dotfiles repo managing both system (NixOS) and user (Home Manager) configuration for a single machine (`earth`). Home Manager is standalone (separate rebuild from NixOS).

## Key Commands

Common tasks are wrapped in the [Justfile](./Justfile) at repo root. Run `just --list` for the menu.

```sh
# Update flake inputs
just update              # wraps: nix flake update

# Bump a custom package's source pin (runs the package's passthru.updateScript)
just update-package <name>  # wraps: nix-update --flake --use-update-script <name>

# Rebuild NixOS system + Home Manager
just upgrade             # wraps: nh os switch && nh home switch

# Clean old generations and optimise the store
just clean               # wraps: nh clean all --keep-since 7d --keep 5 --optimise

# Format all Nix files (uses alejandra, defined in modules/features/flake/formatter.nix)
just format              # wraps: nix fmt .

# Run lint/format checks
just check               # wraps: nix flake check (alejandra, deadnix, statix via git-hooks.nix)
just lint                # runs deadnix + statix directly, faster than `check`

# Load the flake in a Nix REPL (binds inputs + outputs at top level)
just evaluate            # wraps: nix repl --expr 'builtins.getFlake (toString ./.)'

# Install the pre-commit git hook (run once per clone)
just install             # wraps: nix develop --command true

# Edit secrets or re-encrypt for new recipients (after .sops.yaml changes)
just sops-edit           # wraps: sops secrets/secrets.enc.yaml
just sops-rekey          # wraps: sops updatekeys secrets/secrets.enc.yaml
```

The repo is symlinked to `/etc/nixos`. `nh` auto-detects the flake location.

## Architecture

### Dendritic Pattern (flake-parts + import-tree)

The flake uses the [Dendritic Pattern](https://github.com/mightyiam/dendritic): `flake-parts` for top-level module composition and `import-tree` for automatic file discovery. Every `.nix` file under `modules/` is a flake-parts module. Paths containing `/_` are excluded from auto-import.

```nix
# flake.nix
outputs = inputs:
  inputs.flake-parts.lib.mkFlake {inherit inputs;}
  (inputs.import-tree ./modules);
```

### Terminology

- **Configuration**: The evaluated result of combining modules. Three levels exist: the flake-parts configuration (top-level), a NixOS configuration (e.g., `nixosConfigurations.earth`), and a Home Manager configuration (e.g., `homeConfigurations."travis@earth"`).
- **Class**: The target system for a module. The `<class>` in `flake.modules.<class>.<name>` (e.g., `nixos`, `homeManager`).
- **Module**: Overloaded term. A flake-parts module is any `.nix` file under `modules/` (outer layer, receives `{inputs, config, lib, ...}`). A NixOS or HM module is the value inside `flake.modules.<class>.<name>` (inner layer, receives `{config, pkgs, lib, ...}`). Every flake-parts module contains one or more NixOS/HM modules.
- **Feature**: A logical capability like "firefox" or "hyprland." A feature is what a file (or directory) implements. It may have aspects for one or more classes.
- **Aspect**: A feature's contribution to a specific class. If firefox needs both NixOS and HM config, those are two aspects of the firefox feature.
- **Collector**: A pattern where multiple files contribute to the same `flake.modules.<class>.<name>` and their contents merge via `deferredModule` semantics.
- **Base**: The shared baseline config every host/user imports (`flake.modules.<class>.base`). Built from multiple files via the Collector pattern.
- **Profile**: A grouping of features composed into a single importable unit (e.g., "desktop" bundling hyprland, waybar, gtk, etc.). Unlike a feature, a profile doesn't define config itself, it just imports features. Namespaced under `flake.profiles.<class>.<name>`, separate from features at `flake.modules.<class>.<name>`.

### Module Structure

```
modules/
  features/
    desktops/       — Desktop environments (hyprland, gnome) — cross-cutting
    flake/          — Flake infrastructure (flake-parts, builders, formatter, systems)
    hardware/       — Hardware drivers (bluetooth, nvidia, ryzen, xpadneo)
    packages/       — Wiring modules for custom packages (see packages/ below)
    programs/       — Programs (git, firefox, zsh, steam, docker, etc.) — some cross-cutting
    services/       — Services (pipewire, openssh, tailscale, swaync, vicinae, etc.)
    shared/         — Base config (boot, btrfs, facter, fonts, locale, meta, nixpkgs, nix settings, home defaults, sops)
    system/         — System-level config (secure-boot)
  profiles/         — Feature groupings for composition (desktop, gaming)
  systems/          — System definitions (e.g., systems/earth/)
  users/            — User definitions (e.g., users/travis@earth/)
```

### Module Pattern

Feature modules register themselves with `flake.modules.<class>.<name>` where `<class>` is `nixos` or `homeManager`:

```nix
# Simple module (no function args needed)
{
  flake.modules.homeManager.btop = {
    programs.btop = {
      enable = true;
      settings.vim_keys = true;
    };
  };
}

# Cross-cutting module (both classes in one file)
{
  flake.modules.homeManager.firefox = {pkgs, ...}: {
    programs.firefox = { ... };
  };

  flake.modules.nixos.firefox = {
    programs.firefox.enable = true;
  };
}
```

Features are selected by adding them to a host/user's import list — no `mkEnableOption`/`mkIf` boilerplate. In cross-cutting modules, classes are ordered alphabetically (homeManager before nixos).

**Shared modules** (`features/shared/`) contribute to `flake.modules.<class>.base` using the Collector pattern — multiple files all set the same key and their contents merge via `deferredModule` semantics. Every host/user imports `base`. Some shared files are cross-cutting (e.g., `meta.nix` and `nixpkgs.nix` contribute to both classes).

**Multi-file modules** (e.g., `features/desktops/hyprland/`): Multiple files contribute to the same `flake.modules.homeManager.hyprland`. The NixOS aspect lives in `nixos.nix` within the directory. Options can be declared in any file of the group.

**Modules with custom options** (e.g., `gtk.nix`, `jetbrains.nix`, `hyprland`): Declare options under the `internal` namespace to avoid collisions with upstream (e.g., `options.internal.programs.gtk.bookmarks`). Values are set in user/host definitions.

**Modules importing flake inputs** (e.g., `secure-boot.nix`, `vicinae.nix`): The outer function receives flake-parts args (`{inputs, ...}:`), and the inner deferred module captures `inputs` via closure:

```nix
{inputs, ...}: {
  flake.modules.nixos.secure-boot = {lib, pkgs, ...}: {
    imports = [inputs.lanzaboote.nixosModules.lanzaboote];
    # ...
  };
}
```

### Profiles

Profiles group related features into a single importable unit. They use a custom `flake.profiles` option (defined in `features/flake/profiles.nix`) namespaced as `flake.profiles.<class>.<name>`, keeping them separate from features at `flake.modules.<class>.<name>`. Cross-cutting profiles define both classes:

```nix
# modules/profiles/gaming.nix
{inputs, ...}: {
  flake.profiles.homeManager.gaming = {
    imports = with inputs.self.modules.homeManager; [
      discord minecraft osu pcsx2
    ];
  };

  flake.profiles.nixos.gaming = {
    imports = with inputs.self.modules.nixos; [
      bottles heroic lutris steam xpadneo
    ];
  };
}
```

### Host/User Definitions

Hosts and users select profiles and features via import lists:

```nix
# modules/systems/earth/default.nix
{inputs, ...}: {
  flake.modules.nixos.earth = {pkgs, ...}: {
    imports =
      (with inputs.self.profiles.nixos; [
        desktop gaming
      ])
      ++ (with inputs.self.modules.nixos; [
        base bluetooth docker nvidia ...
      ]);
  };
  flake.nixosConfigurations = inputs.self.lib.mkNixos "earth" "x86_64-linux";
}

# modules/users/travis@earth/default.nix
{inputs, ...}: {
  flake.modules.homeManager."travis@earth" = {config, ...}: {
    imports =
      (with inputs.self.profiles.homeManager; [ desktop gaming ])
      ++ (with inputs.self.modules.homeManager; [
        base git firefox zsh ...
      ]);
  };
  flake.homeConfigurations = inputs.self.lib.mkHome "travis@earth" "x86_64-linux";
}
```

Per-host files live in the host directory (e.g., `modules/systems/earth/`): `default.nix` (feature imports, `meta.user`), `disko.nix` (disk layout, contributes to `flake.modules.nixos.<host>` as a collector), and `facter.json` (hardware report from nixos-facter, referenced via `features/shared/facter.nix`).

### Flake Infrastructure (`modules/features/flake/`)

- **`flake-parts.nix`** — Enables the `flake.modules` option
- **`builders.nix`** — `flake.lib.mkNixos` and `flake.lib.mkHome` helpers; `mkNixos` also sets `networking.hostName` and `nixpkgs.hostPlatform` from its arguments
- **`formatter.nix`** — `perSystem` formatter (alejandra)
- **`git-hooks.nix`** — `perSystem` pre-commit hooks (alejandra, deadnix, statix) wired into `nix flake check`, plus a default devShell whose `shellHook` installs the git hook. Statix rule overrides live in `statix.toml` at the repo root, referenced via `${inputs.self}/statix.toml`
- **`systems.nix`** — Supported architectures (`x86_64-linux`)

### Metadata

`meta.*` options are defined in `features/shared/meta.nix` (cross-cutting) and set in host/user definitions:
- `config.meta.flake` (both classes) — absolute path to the working tree of this flake; defaults to `/etc/nixos`. Used by modules that need a non-store path (e.g., `mkOutOfStoreSymlink` for live-editable configs, `programs.nh.flake`). Override per-host if the flake lives elsewhere.
- NixOS: `config.meta.user.{description, shell, username}` — `shell` defaults to `pkgs.zsh` and is consumed by `features/shared/user.nix` to set `users.defaultUserShell`.
- Home Manager: `config.meta.user.{name, email, signingKey, username}`

### Secrets

Managed with `sops-nix`. Cross-cutting setup lives in `features/shared/secrets.nix` for both classes; an `mkSopsConfig` helper there factors out the shared boilerplate (`defaultSopsFile`, `validateSopsFiles`, `age.keyFile = ""`) and parametrizes the SSH key path per class (host key for NixOS, user key for Home Manager). `features/shared/config.nix` retains class-specific secrets/templates (e.g., `GITHUB_ACCESS_TOKEN`, generated `nix.conf`). Encrypted secrets live in `secrets/secrets.enc.yaml`, decrypted at runtime via SOPS native SSH support (`SOPS_AGE_SSH_PRIVATE_KEY_FILE`). The `.sops.yaml` uses raw `ssh-ed25519` public keys as recipients. Modules can reference secrets via `config.sops.secrets.<name>` or template them with `sops.templates`.

### Disk layout

Per-host disk layout is declared via `disko` in `modules/systems/<host>/disko.nix` as a flake-parts collector contributing to `flake.modules.nixos.<host>`; the `disko` NixOS module generates `fileSystems` and `boot.initrd.luks.devices` from that declaration. The earth layout describes existing partitions (it was adopted onto a running system), so partitions set explicit `label = "..."` matching on-disk GPT partlabels, and LUKS `name = "luks-<uuid>"` preserves the device mapper path used by the current initrd. Never run the destructive `disko` CLI — the module-only path is what's wired up.

### Pre-commit hooks

Two enforcement surfaces for the lint/format stack (alejandra, deadnix, statix):

1. **`nix flake check`** — runs the hooks as a derivation against the full source tree. Always works, no install step.
2. **Local git pre-commit hook** — runs on `git commit` against staged files only. Requires a one-time install per clone: entering `nix develop` triggers the devShell's `shellHook`, which writes `.git/hooks/pre-commit` and generates `.pre-commit-config.yaml` at the repo root. Both are host-local artifacts; `.pre-commit-config.yaml` is gitignored.

Statix rule overrides (e.g. disabling `repeated_keys`) live in `statix.toml` at the repo root, referenced from the hook module via `${inputs.self}/statix.toml`.

### Hardware detection

Per-host hardware detection is declared via `nixos-facter` in `modules/systems/<host>/facter.json`; the `hardware.facter` NixOS module (upstreamed in nixpkgs) consumes the report and derives kernel modules for disk/USB/network/graphics, CPU microcode, redistributable firmware, `hostPlatform`, `kvm-{amd,intel}`, and per-interface DHCP. `features/shared/facter.nix` wires `reportPath` from the flake root plus `config.networking.hostName`, and disables facter's per-interface DHCP when NetworkManager is enabled. Generate with `sudo nix run nixpkgs#nixos-facter -- -o facter.json` and regenerate when hardware changes. Replaces the manually-maintained `hardware-configuration.nix`.

### Custom packages

Custom derivations live under `packages/<name>/` (outside `modules/` so import-tree doesn't try to evaluate them as flake-parts modules). Each package is wired by a per-file module at `modules/features/packages/<name>.nix` that both exposes the package as a flake output and provides a cross-cutting feature module:

```nix
{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.<name> = pkgs.callPackage "${inputs.self}/packages/<name>" {};
  };

  flake.modules.homeManager.<name> = {pkgs, ...}: {
    home.packages = [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.<name>
    ];
  };
}
```

Path references use `${inputs.self}/<path>` rather than `../../../<path>` (matches the `statix.toml` pattern in `git-hooks.nix`). Features are consumed by adding `<name>` to the host/user import list like any other feature.

Packages should ship a `passthru.updateScript` — a bash script that regenerates a sibling `sources.json` (hashes, version, git refs). Bump via `just update-package <name>`, which wraps `nix-update --flake --use-update-script <name>`. Update scripts must anchor output paths to `$PWD` (nix-update sets cwd to the flake root) rather than `$BASH_SOURCE`, which resolves to the read-only nix store path when invoked via `updateScript`. Source bumps are a separate, deliberate step — neither `nix flake update` nor `nh os/home switch` touch `passthru.updateScript`.

See `docs/dendritic/roadmap.md` for documented extension paths (specialArg injection, namespaced overlay) if consumer boilerplate starts to grate.

Static config files, overlays, and assets are colocated with their feature modules (e.g., `modules/features/programs/mpv/` contains both the module and its config files).

### Flake Inputs

Key dependencies: `nixpkgs` (unstable), `flake-parts`, `import-tree`, `home-manager`, `disko` (declarative disk layout), `git-hooks` (pre-commit framework), `lanzaboote` (Secure Boot), `sops-nix` (secrets), `wallpapers` (non-flake), `vicinae` (launcher).

### Further documentation

- `docs/dendritic/roadmap.md` — post-migration roadmap: profiles, tag-based composition, custom-package extension paths
