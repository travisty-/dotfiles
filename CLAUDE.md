# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A NixOS flake-based personal dotfiles repo managing both system (NixOS) and user (Home Manager) configuration for a single machine (`earth`).

## Key Commands

```sh
# Rebuild NixOS system configuration
nh os switch # or: sudo nixos-rebuild switch --flake .#earth

# Rebuild Home Manager user configuration
nh home switch # or: home-manager switch --flake .#travis@earth

# Format all Nix files (uses alejandra, defined in flake.nix)
nix fmt .

# Update flake inputs
nix flake update
```

The repo is symlinked to `/etc/nixos`. `nh` auto-detects the flake location.

## Architecture

### Namespace Pattern

All custom module options live under `internal.*` (set via `namespace = "internal"` in flake.nix). This avoids collisions with upstream NixOS/Home Manager options. Modules reference it as `config.${namespace}.*` and options are declared under `options.${namespace}.*`.

### Module Structure

Two parallel module trees, both auto-imported via `lib.internal.import`:

- **`modules/nixos/`** — System-level: hardware drivers, system services, desktop environment setup, boot config
- **`modules/home/`** — User-level: program configs, dotfiles, desktop customization, user services

Each tree has a `default.nix` that calls `lib.internal.import ./.` to auto-discover all `.nix` files (excluding `default.nix` itself and paths containing `/_`). Files prefixed with `/_` are intentionally excluded from auto-import.

### Module Pattern

Every module follows this structure:

```nix
{config, lib, namespace, ...}: let
  cfg = config.${namespace}.programs.example;
in {
  options.${namespace}.programs.example = {
    enable = lib.mkEnableOption "Example";
  };

  config = lib.mkIf cfg.enable {
    # actual configuration
  };
}
```

Modules are enabled in system/home configs using helpers from `lib/module.nix`:
- `enabled` = `{enable = true;}`
- `disabled` = `{enable = false;}`

### Custom Library (`lib/`)

`lib/default.nix` extends `nixpkgs.lib` with `lib.internal.*`:
- `lib.internal.import` — auto-discovers `.nix` files in a directory
- `lib.internal.enabled` / `lib.internal.disabled` — shorthand for enable flags

### System/Home Configs

- **`systems/earth/`** — NixOS config: enables `internal.*` modules, sets up SOPS secrets, hardware
- **`homes/travis@earth/`** — Home Manager config: enables `internal.*` program/service/desktop modules

User metadata (`meta.user`) is defined via options in `modules/*/options/meta.nix` and set in the system/home configs. Modules access it as `config.meta.user.{name,email,username,signingKey}`.

### Other Directories

- **`overlays/`** — Package overrides (pop-shell, qbittorrent, spotify)
- **`packages/`** — Custom package derivations (raindrop)
- **`files/`** — Static config files referenced by home modules (mpv, jetbrains, gnome, powershell)

### Flake Inputs

Key dependencies: `nixpkgs` (unstable), `home-manager`, `lanzaboote` (Secure Boot), `sops-nix` (secrets), `wallpapers` (non-flake), `vicinae` (launcher).
