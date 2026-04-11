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

Each tree has a `default.nix` that calls `lib.internal.import ./.` to auto-discover all `.nix` files (excluding `default.nix` itself and paths containing `/_`). Files prefixed with `/_` are intentionally excluded from auto-import. New `.nix` files added anywhere under these trees are picked up automatically — no import list to update.

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

The option path mirrors the file's location under `modules/`: `modules/home/programs/git.nix` → `${namespace}.programs.git`, `modules/nixos/hardware/nvidia.nix` → `${namespace}.hardware.nvidia`.

Modules are enabled in system/home configs using helpers from `lib/module.nix`. The configs bring these into scope with `with lib.${namespace};`:
- `enabled` = `{enable = true;}`
- `disabled` = `{enable = false;}`

**Shared modules** (`modules/*/shared/`) are unconditionally active — they have no `enable` option and no `mkIf` guard. They set baseline config (locale, nix settings, user account, home-manager defaults).

**Multi-file modules**: A feature like `desktop.hyprland` can be split across multiple files in a subdirectory (e.g., `modules/home/desktop/hyprland/`). All files share the same `cfg = config.${namespace}.desktop.hyprland` and guard on `cfg.enable`, so they act as one logical module. Options can be declared in any of the files.

### Custom Library (`lib/`)

`lib/default.nix` extends `nixpkgs.lib` with `lib.internal.*`:
- `lib.internal.import` — auto-discovers `.nix` files in a directory
- `lib.internal.enabled` / `lib.internal.disabled` — shorthand for enable flags

Note: the Nix pipe operator (`|>`) is enabled via `experimental-features` in `modules/nixos/shared/settings.nix` and used in lib code.

### System/Home Configs

- **`systems/earth/`** — NixOS config: enables `internal.*` modules, sets up SOPS secrets, hardware
- **`homes/travis@earth/`** — Home Manager config: enables `internal.*` program/service/desktop modules

User metadata (`meta.user`) is defined via options in `modules/*/options/meta.nix` and set in the system/home configs. The NixOS and Home Manager meta options differ:
- NixOS: `config.meta.user.{description, username}`
- Home Manager: `config.meta.user.{name, email, signingKey, username}`

### Secrets

Managed with `sops-nix`. Encrypted secrets live in `secrets/secrets.enc.yaml`, decrypted at runtime via age keys derived from SSH keys. Modules can reference secrets via `config.sops.secrets.<name>` or template them into config files with `sops.templates`.

### Other Directories

- **`overlays/`** — Package overrides
- **`packages/`** — Custom package derivations
- **`files/`**    — Static config files referenced by home modules

### Flake Inputs

Key dependencies: `nixpkgs` (unstable), `home-manager`, `lanzaboote` (Secure Boot), `sops-nix` (secrets), `wallpapers` (non-flake), `vicinae` (launcher).
