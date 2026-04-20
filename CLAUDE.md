# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A NixOS flake-based personal dotfiles repo managing both system (NixOS) and user (Home Manager) configuration for a single machine (`earth`). Home Manager is standalone (separate rebuild from NixOS).

## Key Commands

```sh
# Rebuild NixOS system configuration
nh os switch # or: sudo nixos-rebuild switch --flake .#earth

# Rebuild Home Manager user configuration
nh home switch # or: home-manager switch --flake .#travis@earth

# Format all Nix files (uses alejandra, defined in modules/flake/formatter.nix)
nix fmt .

# Update flake inputs
nix flake update
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
- **Profile** or **Component** (not yet implemented): A grouping of features composed into a single importable unit (e.g., a "cli" profile bundling zsh, eza, fd, fzf, etc.). Unlike a feature, a profile doesn't define config itself, it just imports features. Naming TBD.

### Module Structure

```
modules/
  flake/          — Flake infrastructure (flake-parts, builders, formatter, systems)
  nixos/          — NixOS feature modules
    desktop/      — Desktop environment (hyprland, gnome)
    hardware/     — Hardware drivers (bluetooth, nvidia, ryzen, xpadneo)
    options/      — Option declarations (meta.user)
    programs/     — System-level programs (docker, steam, 1password, etc.)
    services/     — System services (pipewire, openssh, tailscale, etc.)
    shared/       — Base NixOS config (boot, fonts, locale, nix settings, sops, user)
    system/       — System-level config (secure-boot)
  home/           — Home Manager feature modules
    desktop/      — Desktop customization (hyprland, gnome)
    options/      — Option declarations (meta.user)
    programs/     — User programs (git, firefox, zsh, etc.)
    services/     — User services (swaync, vicinae)
    shared/       — Base HM config (home defaults, sops, nix.conf)
  hosts/          — Host definitions (e.g., hosts/earth/)
  users/          — User definitions (e.g., users/travis@earth.nix)
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

# Module needing NixOS/HM args
{
  flake.modules.nixos.bluetooth = {config, ...}: {
    hardware.bluetooth.enable = true;
  };
}
```

Features are selected by adding them to a host/user's import list — no `mkEnableOption`/`mkIf` boilerplate.

**Shared modules** (`*/shared/`) contribute to `flake.modules.<class>.base` using the Collector pattern — multiple files all set the same key and their contents merge via `deferredModule` semantics. Every host/user imports `base`.

**Multi-file modules** (e.g., `home/desktop/hyprland/`): Multiple files contribute to the same `flake.modules.homeManager.hyprland`. Options can be declared in any file of the group.

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

### Host/User Definitions

Hosts and users select features via import lists:

```nix
# modules/hosts/earth/default.nix
{inputs, ...}: {
  flake.modules.nixos.earth = {pkgs, ...}: {
    imports = [./_config/configuration.nix]
      ++ (with inputs.self.modules.nixos; [
        base bluetooth docker nvidia pipewire ...
      ]);
    # host-specific config (meta, sops, etc.)
  };
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "earth";
}

# modules/users/travis@earth.nix
{inputs, ...}: {
  flake.modules.homeManager."travis@earth" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      base hyprland git firefox zsh ...
    ];
    # user-specific config (meta, sops, option values)
  };
  flake.homeConfigurations = inputs.self.lib.mkHome "x86_64-linux" "travis@earth";
}
```

Auto-generated NixOS files (`configuration.nix`, `hardware-configuration.nix`) live in `_config/` subdirectories within the host, excluded from import-tree.

### Flake Infrastructure (`modules/flake/`)

- **`flake-parts.nix`** — Enables the `flake.modules` option
- **`builders.nix`** — `flake.lib.mkNixos` and `flake.lib.mkHome` helpers
- **`formatter.nix`** — `perSystem` formatter (alejandra)
- **`systems.nix`** — Supported architectures (`x86_64-linux`)

### User Metadata

`meta.user` options are defined in `modules/*/options/meta.nix` and set in host/user definitions:
- NixOS: `config.meta.user.{description, username}`
- Home Manager: `config.meta.user.{name, email, signingKey, username}`

### Secrets

Managed with `sops-nix`. The sops-nix module is imported in the shared base modules (`nixos/shared/secrets.nix`, `home/shared/config.nix`). Encrypted secrets live in `secrets/secrets.enc.yaml`, decrypted at runtime using SSH keys directly via SOPS native SSH support (`SOPS_AGE_SSH_PRIVATE_KEY_FILE`). The `.sops.yaml` uses raw `ssh-ed25519` public keys as recipients. Modules can reference secrets via `config.sops.secrets.<name>` or template them with `sops.templates`.

### Other Directories

- **`overlays/`** — Custom package overrides
- **`packages/`** — Custom package derivations
- **`files/`**    — Static config files and images referenced by modules

### Flake Inputs

Key dependencies: `nixpkgs` (unstable), `flake-parts`, `import-tree`, `home-manager`, `lanzaboote` (Secure Boot), `sops-nix` (secrets), `wallpapers` (non-flake), `vicinae` (launcher).
