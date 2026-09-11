# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A NixOS flake-based personal dotfiles repo managing both system (NixOS) and user (Home Manager) configuration.
Currently one host (`earth`) and one user (`travis@earth`); the layout is multi-host and multi-user capable.
Home Manager is standalone (separate rebuild from NixOS).
The flake's working tree is `/etc/nixos` (recorded in `meta.flake`); `nh` auto-detects it.

## Key commands

Common tasks are wrapped in the [Justfile](./Justfile) at repo root.
Run `just --list` for the full list.

```sh
just update [input ...]     # nix flake update, optionally limited to specific inputs
just update-package <name>  # bump a custom package's source pin via its passthru.updateScript
just upgrade                # nh os switch && nh home switch
just clean                  # nh clean all --keep-since 7d --keep 5 --optimise
just format                 # nix fmt . (treefmt: alejandra, fish_indent, rumdl-format)
just check                  # nix flake check (runs the pre-commit hooks as a derivation)
just lint                   # deadnix + statix + rumdl directly, faster than check
just evaluate               # nix repl with the flake's inputs + outputs bound at top level
just install                # one-time per clone: install the pre-commit git hook
just sops-edit              # edit encrypted secrets
just sops-rekey             # re-encrypt secrets after recipient changes in .sops.yaml
```

The git recipes (`amend`, `fixup`, `rebase <count>`, `push`) are in the global justfile (`modules/features/programs/just/Justfile`) and run from any repo, including this one, as `gust <recipe>`.
They wrap an autosquash-centric history flow; `gust push` force-pushes with `--force-with-lease --force-if-includes`.

## Inspecting & verifying a change

Iterating on a module without a full `just upgrade`.
NixOS and Home Manager are separate flake outputs, so target whichever you touched (`nixosConfigurations.earth`, `homeConfigurations."travis@earth"`):

- **Eval one value** (fastest feedback; add `--json` / `--apply` to project or pretty-print):
    - NixOS: `nix eval .#nixosConfigurations.earth.config.services.restic.backups.b2.exclude`
    - Home Manager: `nix eval '.#homeConfigurations."travis@earth".config.home.homeDirectory'`
- **Build without switching**:
    - NixOS: `nh os build` (or `nix build .#nixosConfigurations.earth.config.system.build.toplevel`)
    - Home Manager: `nh home build` (or `nix build '.#homeConfigurations."travis@earth".activationPackage'`)
- **Full lint/format/eval gate**: `just check`.

Stage new files (`git add`) before evaluating; `nix eval`, `nix build`, and `just check` cannot see them until staged.
The flake is a dirty local git tree, so Nix reads the _working-tree_ contents of **tracked** files only.

## Architecture

### Dendritic pattern (flake-parts + import-tree)

The flake uses the [Dendritic Pattern](https://github.com/mightyiam/dendritic): `flake-parts` for top-level module composition and `import-tree` for automatic file discovery.
Every `.nix` file under `modules/` is a flake-parts module.
Paths containing `/_` are excluded from auto-import.
Effectively a vertical slice architecture: each feature manages its full cross-class implementation in one place.

```nix
# flake.nix
outputs = inputs:
  inputs.flake-parts.lib.mkFlake {inherit inputs;}
  (inputs.import-tree ./modules);
```

### Terminology

#### Configuration

The evaluated result of combining modules.
Three levels exist:

1. The flake-parts configuration (top-level)
2. A NixOS configuration (e.g., `nixosConfigurations.earth`)
3. A Home Manager configuration (e.g., `homeConfigurations."travis@earth"`)

#### Class

The target system for a module.
The `<class>` in `flake.modules.<class>.<aspect>` (e.g., `nixos`, `homeManager`).

#### Module

Overloaded term.
A flake-parts module is the outer layer, receiving `{inputs, config, lib, ...}`.
A NixOS or HM module is the inner layer: the value inside `flake.modules.<class>.<aspect>`, receiving `{config, pkgs, lib, ...}`.
Every flake-parts module contains one or more NixOS/HM modules.

#### Feature

A logical capability like "Firefox" or "Niri."
A feature is what a file (or directory) implements.
It wraps a single aspect, which can span one or more classes.

#### Aspect

The concrete thing a feature configures (a package, a program, a service), registered under each class the feature targets.
If Firefox needs both NixOS and HM config, that single aspect covers the `nixos` and `homeManager` classes.

#### Collector

A pattern where multiple files contribute to the same `flake.modules.<class>.<aspect>` and their contents merge via `deferredModule` semantics.

#### Base

The shared baseline config every host/user imports (`flake.modules.<class>.base`).
Built from multiple files via the Collector pattern.

#### Profile

A grouping of features composed into a single importable unit (e.g., "desktop" bundling Niri, Noctalia, GTK, etc.).
Unlike a feature, a profile doesn't define config itself, it just imports features.
Namespaced under `flake.profiles.<class>.<name>`, separate from features at `flake.modules.<class>.<aspect>`.

### Module structure

```text
modules/
  features/
    desktops/       # Compositor (niri) and desktop shell (noctalia), cross-cutting
    flake/          # Flake infrastructure (flake-parts, builders, formatter, git-hooks, profiles, systems)
    hardware/       # Hardware drivers and tuning (bluetooth, nvidia, ryzen, xpadneo, ...)
    packages/       # Wiring modules for custom packages (see packages/ at repo root)
    programs/       # Desktop applications and CLI tools, some cross-cutting
    services/       # Background services (pipewire, openssh, tailscale, btrbk, restic, ...)
    shared/         # Base config every host/user imports (boot, locale, nix settings, sops, ...)
    system/         # System-level features (disko, secure-boot)
  profiles/         # Feature groupings (cli, desktop, development, gaming, media, productivity, shell)
  systems/          # Host definitions (e.g., systems/earth/)
  users/            # User definitions (e.g., users/travis@earth/)
```

### Module pattern

Feature modules register themselves with `flake.modules.<class>.<aspect>` where `<class>` is `nixos` or `homeManager`:

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

Features are selected by adding them to a host/user's import list (no `mkEnableOption`/`mkIf` boilerplate).
In cross-cutting modules, classes are ordered alphabetically (homeManager before nixos).

**Shared modules** (`features/shared/`) contribute to `flake.modules.<class>.base` using the Collector pattern; every host/user imports `base`.
Some shared files are cross-cutting (e.g., `meta.nix` and `nixpkgs.nix` contribute to both classes).

**Multi-file modules** (e.g., `features/desktops/niri/`, `features/desktops/noctalia/`): Multiple files contribute to the same `flake.modules.<class>.<aspect>` and merge via `deferredModule` semantics.
The NixOS module of an HM-named feature goes in `nixos.nix` within the directory; option declarations get a dedicated `options.nix`.

**`let` bindings are file-local.**
A `let` in one file of a multi-file module isn't visible in its siblings.
To share a computed value across them, set `_module.args.<name> = ...` inside the deferred module and each contributing file receives it as a regular argument; the arg name is configuration-global, so two features both naming `scripts` would collide.
Nothing currently needs cross-file sharing.

**Auto-discovery via `_scripts.nix`.**
The Niri feature turns its sibling `scripts/` directory into one package via a colocated helper, `modules/features/desktops/niri/_scripts.nix`; the `/_` prefix keeps import-tree from evaluating it as a flake-parts module, so it stays a plain `{pkgs}:` function.
It wraps every regular file under `scripts/` with `pkgs.writeShellScriptBin` and joins them into one `pkgs.symlinkJoin` derivation, imported in `niri.nix`'s `let` as `scripts` and referenced as `${scripts}/bin/<name>`.
It hardcodes `./scripts` precisely because it's colocated: a path default in a shared `flake.lib` helper would resolve relative to the helper's own file, not the caller's.
Drop a new file in `scripts/`, reference its bin path; no further Nix wiring needed.

**Colocated assets** ship next to their feature module: `programs/mpv/` holds the module plus its config files, and `desktops/noctalia/colorschemes.nix` sources the sibling `colorschemes/` directory wholesale via `xdg.configFile` with `recursive = true`.

**Hybrid defaults via `importJSON` + `recursiveUpdate`** (`desktops/noctalia/settings.nix`): `importJSON` the upstream `Assets/settings-default.json` at eval time, then `recursiveUpdate defaults {...}` so the on-disk file matches the in-memory shape while the declaration carries only real deltas.
A `mkWidget` helper pulls per-widget defaults from `widgetDefaults.bar.${widget.id}`.
The point is reproducible diffs: `just diff-settings` shows only what actually changed via the GUI vs. what Nix declares.

**Modules with custom options** (`gtk.nix`, `jetbrains/`, `niri/options.nix`): Declare options under the `internal` namespace to avoid collisions with upstream (e.g., `options.internal.programs.gtk.bookmarks`).
Values are set in user/host definitions.

**Modules importing flake inputs** (e.g., `system/secure-boot.nix`, `programs/vicinae.nix`): The outer function receives flake-parts args (`{inputs, ...}:`), and the inner deferred module captures `inputs` via closure:

```nix
{inputs, ...}: {
  flake.modules.nixos.secure-boot = {lib, pkgs, ...}: {
    imports = [inputs.lanzaboote.nixosModules.lanzaboote];
    # ...
  };
}
```

### Profiles

Profiles group related features into a single importable unit.
They use a custom `flake.profiles` option (declared in `features/flake/profiles.nix`) namespaced as `flake.profiles.<class>.<name>`, keeping them separate from features at `flake.modules.<class>.<aspect>`.
Current profiles: `cli`, `desktop`, `development`, `gaming`, `media`, `productivity`, `shell`.
Cross-cutting profiles define both classes:

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

### Host and user conventions

Hosts and users select profiles and features via import lists, then fill in `meta.*` and `internal.*` values:

```nix
# modules/systems/earth/default.nix
{inputs, ...}: {
  flake.modules.nixos.earth = {pkgs, ...}: {
    imports =
      (with inputs.self.profiles.nixos; [desktop development gaming media shell])
      ++ (with inputs.self.modules.nixos; [base bluetooth disko nvidia restic ...]);

    meta.user = {
      description = "Travis Kinney";
      username = "travis";
      shell = pkgs.fish;
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "earth" "x86_64-linux";
}
```

The user definition (`modules/users/travis@earth/default.nix`) follows the same shape with `mkHome`, plus HM-side `meta.user` (name, email, signingKey) and `internal.*` values (niri outputs, GTK bookmarks, JetBrains IDE toggles).
The host directory (`modules/systems/earth/`) holds `default.nix` (feature imports, `meta.user`), `disko.nix` (disk layout, a collector contributing to `flake.modules.nixos.<host>`), and `facter.json` (hardware report).

### Flake infrastructure

The flake-level plumbing is in `modules/features/flake/`:

- `flake-parts.nix`: Enables the `flake.modules` option
- `builders.nix`: `flake.lib.mkNixos` and `flake.lib.mkHome`; both pass `inputs` through `specialArgs`/`extraSpecialArgs`, and `mkNixos` additionally sets `networking.hostName` and `nixpkgs.hostPlatform` (as `mkDefault`) from its arguments
- `formatter.nix`: The treefmt-nix multiplexer behind `nix fmt`: alejandra (Nix), fish_indent (fish), rumdl-format (Markdown)
- `git-hooks.nix`: perSystem pre-commit hooks wired into `nix flake check`, plus the default devShell whose `shellHook` installs the git hook (see [Pre-commit hooks](#pre-commit-hooks))
- `profiles.nix`: Declares the `flake.profiles` option (`attrsOf (attrsOf deferredModule)`)
- `systems.nix`: Supported architectures (currently `x86_64-linux`)

### Metadata

`meta.*` options are defined in `modules/features/shared/meta.nix` (cross-cutting) and set in host/user definitions:

- `config.meta.flake` (both classes): Absolute path to the working tree of this flake; defaults to `/etc/nixos`.
  Used by modules that need a non-store path (e.g., `mkOutOfStoreSymlink` for live-editable configs, `programs.nh.flake`).
  Override per-host if the flake is checked out elsewhere.
- NixOS: `config.meta.user.{description, shell, username}`.
  `shell` defaults to `pkgs.zsh` and is consumed by `features/shared/user.nix` to set `users.defaultUserShell`; earth currently sets `pkgs.fish`.
- Home Manager: `config.meta.user.{name, email, signingKey, username}`.
  `signingKey` is optional (`nullOr`, default `null`): an SSH public key that enables commit signing when set.

### Secrets

Managed with sops-nix.
Cross-cutting setup is in `modules/features/shared/secrets.nix` for both classes.
An `mkSopsConfig` helper there factors out the shared boilerplate (`defaultSopsFile`, `validateSopsFiles`, `age.keyFile = ""`).
It parametrizes the SSH key path per class: the host key `/etc/ssh/ssh_host_ed25519_key` for NixOS, the user key `~/.ssh/id_ed25519` for Home Manager.
The empty `age.keyFile` bypasses ssh-to-age key conversion so no intermediate `age-keys.txt` is generated; temporary workaround until sops-nix supports SSH keys natively (sops-nix#695, sops-nix#824).
`features/shared/config.nix` holds class-specific secrets/templates (e.g., `GITHUB_ACCESS_TOKEN` and the generated `nix.conf` that embeds it as a GitHub access token).
Encrypted secrets are stored in `secrets/secrets.enc.yaml`, decrypted at runtime via SOPS native SSH support (`SOPS_AGE_SSH_PRIVATE_KEY_FILE`).
The `.sops.yaml` uses raw `ssh-ed25519` public keys as recipients.
Modules reference secrets via `config.sops.secrets.<name>` or template them with `sops.templates`.
Edit with `just sops-edit`; after changing recipients in `.sops.yaml`, run `just sops-rekey`.

### Disk layout

The `disko` feature (`modules/features/system/disko.nix`) imports the upstream disko NixOS module; hosts opt in by importing the feature.
Per-host layout is declared in `modules/systems/<host>/disko.nix`, a flake-parts collector contributing to `flake.modules.nixos.<host>`.
The disko module generates `fileSystems` and `boot.initrd.luks.devices` from that declaration.
The earth layout describes existing partitions (it was adopted onto a running system).
Partitions set explicit `label = "..."` matching on-disk GPT partlabels, and LUKS `name = "luks-<uuid>"` preserves the device mapper path used by the current initrd.

**Caution**: Never run the destructive `disko` CLI; the module-only path is what's wired up.

### Backups

Two complementary features cover home-directory recovery:

- **`services/btrbk.nix`**: Hourly read-only BTRFS snapshots of `/home` into `/.snapshots/`.
  Provides instant local rollback for accidental deletions (`cp /.snapshots/home.<timestamp>/path .`).
  Same disk as the source, so it's a recovery convenience, not a backup against drive failure.
- **`services/restic.nix`**: Daily encrypted backup of `/home` to Backblaze B2 via the S3-compatible API.
  The repository path is `<bucket>/<username>@<hostname>` so future hosts can share a bucket.
  Credentials (`RESTIC_PASSWORD`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) are SOPS secrets.

The NixOS restic module generates a `restic-b2` wrapper with the repository and credentials preset; run it with `sudo` for manual repository operations.
`just restic-excluded` audits what the exclude rules skip, largest directories first.

The two keystones for recovery are `RESTIC_PASSWORD` and the host SSH key that doubles as the SOPS age key (`/etc/ssh/ssh_host_ed25519_key`).
Both must be escrowed off-machine; neither is in the flake.
Either alone suffices: the password decrypts the repository directly, and the SSH key recovers the password from the pushed encrypted secrets.
Losing both renders the backup unrecoverable.

### Pre-commit hooks

Two enforcement surfaces for the lint/format stack:

1. **`nix flake check`**: Runs the hooks as a derivation against the full source tree.
   Always works, no install step.
2. **Local git pre-commit hook**: Runs on `git commit` against staged files only.
   Requires a one-time install per clone: entering `nix develop` (or `just install`) triggers the devShell's `shellHook`, which writes `.git/hooks/pre-commit` and links `.pre-commit-config.yaml` (a store symlink) at the repo root.
   Both are host-local artifacts; `.pre-commit-config.yaml` is gitignored.

Enabled hooks (`modules/features/flake/git-hooks.nix`): deadnix, rumdl, shellcheck, statix, and treefmt.
The treefmt hook reuses the `nix fmt` wrapper, so formatting checks (alejandra, fish_indent, rumdl-format) match `just format` exactly.
The devShell also provides `just` and the treefmt wrapper.

Per-linter config files at the repo root:

- `statix.toml`: Statix rule overrides (e.g., disabling `repeated_keys`), referenced from the hook module via `${inputs.self}/statix.toml`.
- `.rumdl.toml`: Markdown rules; notably MD013 reflows prose to one sentence per line and MD063 enforces sentence-case headings.

### Hardware detection

Per-host hardware detection is declared via nixos-facter in `modules/systems/<host>/facter.json`; the `hardware.facter` NixOS module (upstream in nixpkgs) consumes the report and derives kernel modules for disk/USB/network/graphics, CPU microcode, redistributable firmware, `hostPlatform`, `kvm-{amd,intel}`, and per-interface DHCP.
`features/shared/facter.nix` wires `reportPath` from the flake root plus `config.networking.hostName`, and disables facter's per-interface DHCP when NetworkManager is enabled.
Generate with `sudo nix run nixpkgs#nixos-facter -- -o facter.json` and regenerate when hardware changes.
Replaces the manually-maintained `hardware-configuration.nix`.

### Session start

No display manager.
`getty@tty1.service` shows a standard `login:` prompt.
After credentials, the login shell execs `niri-session -l`, but only when `$XDG_VTNR` is 1 and `$WAYLAND_DISPLAY` is empty, so other VTs and SSH sessions drop into a normal shell.
Both shells are wired in `modules/features/desktops/niri/settings.nix`: zsh via `programs.zsh.loginExtra`, fish via `programs.fish.loginShellInit`.
The `-l` argument bypasses niri-session's internal login-shell re-exec; without it the wrapper re-sources the login config and infinite-loops ([niri-wm/niri#1914](https://github.com/niri-wm/niri/issues/1914)).
The flag is undocumented but stable in practice; niri-session uses it as its own internal "already wrapped" marker.

### Custom packages

Custom derivations go under `packages/<name>/` (outside `modules/` so import-tree doesn't try to evaluate them as flake-parts modules); `raindrop` is the current example.
Each package is wired by a per-file module at `modules/features/packages/<name>.nix` that both exposes the package as a flake output and provides a feature module:

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

Path references use `${inputs.self}/<path>` rather than `../../../<path>`.
Features are consumed by adding `<name>` to the host/user import list like any other feature.

Packages should ship a `passthru.updateScript`, a bash script that regenerates a sibling `sources.json` (hashes, version, git refs).
Bump via `just update-package <name>`, which wraps `nix-update --flake --use-update-script <name>`.
Update scripts must anchor output paths to `$PWD` (nix-update sets cwd to the flake root) rather than `$BASH_SOURCE`, which resolves to the read-only nix store path when invoked via `updateScript`.
Source bumps are a separate, deliberate step; neither `nix flake update` nor `nh os/home switch` touch `passthru.updateScript`.

### Flake inputs

Key dependencies: `nixpkgs` (unstable), `flake-parts`, `import-tree`, `home-manager`, `disko` (declarative disk layout), `git-hooks` (pre-commit framework), `treefmt-nix` (formatter multiplexer), `lanzaboote` (Secure Boot), `sops-nix` (secrets), `wallpapers` (non-flake), `vicinae` (launcher), `niri` (sodiboo/niri-flake), `noctalia` (Quickshell-based desktop shell).

**Cachix-backed inputs deliberately skip `inputs.nixpkgs.follows = "nixpkgs"`** (`niri`, `vicinae`, `noctalia`).
Following our nixpkgs would override their pinned revision, change derivation hashes, and miss their hosted binary caches (`niri.cachix.org`, `vicinae.cachix.org`, `noctalia.cachix.org`), forcing local source compiles on every bump.
The closure-size cost of an extra nixpkgs revision is the deliberate tradeoff.
The other inputs (`disko`, `git-hooks`, `home-manager`, `lanzaboote`, `sops-nix`, `treefmt-nix`) follow safely because they ship Nix modules / build infrastructure rather than precompiled binaries; the hash divergence has no real cost.

## Other documentation

- `docs/workspace/` (gitignored): Personal scratch area for research notes, the TODO list (`todo.md`), per-topic review docs, and the cross-project issue tracker (`issue-tracker.md`).
  Treat it as the source of truth for open questions and pending work; check `issue-tracker.md` before filing upstream issues.
  Front doors: `firefox/migration.md` (migration in progress) and `neovim/migration.md` (Lua config in [travisty-/neovim](https://github.com/travisty-/neovim), cloned to `~/.config/nvim` via `just clone`).
