# Dotfiles

My personal dotfiles, managed with Nix.

## Components

| Role          | Program               |
| ------------- | --------------------- |
| Compositor    | Niri                  |
| Desktop shell | Noctalia (Quickshell) |
| Launcher      | Vicinae               |
| Terminal      | Ghostty               |
| Editor        | Neovim[^1], VS Code   |
| File manager  | Yazi, Nautilus        |
| Browser       | Firefox               |

## Infrastructure

- Module system via [`flake-parts`](https://github.com/hercules-ci/flake-parts) and [`import-tree`](https://github.com/vic/import-tree)
- Disk partitioning via [`disko`](https://github.com/nix-community/disko)
- Hardware detection via [`nixos-facter`](https://github.com/nix-community/nixos-facter)
- Pre-commit hooks via [`git-hooks.nix`](https://github.com/cachix/git-hooks.nix)
- Formatting (tree) via [`treefmt-nix`](https://github.com/numtide/treefmt-nix)
- Scheduled backups via [`restic`](https://github.com/restic/restic)
- Secret management via [`sops-nix`](https://github.com/Mic92/sops-nix)
- Secure boot via [`lanzaboote`](https://github.com/nix-community/lanzaboote)

[^1]: Configuration in [travisty-/neovim](https://github.com/travisty-/neovim).

## Overview

```text
.
├── docs/
│   ├── how-to/         # Task-oriented guides
│   └── reference/      # Reference documentation
├── modules/            # Import root. Every .nix file is auto-imported
│   ├── features/       # One file (or directory) per logical capability
│   │   ├── desktops/   # Desktop environments, compositors, and shells
│   │   ├── flake/      # Flake infrastructure and builders
│   │   ├── hardware/   # Drivers, hardware-specific tuning
│   │   ├── packages/   # Wiring for custom packages (see /packages)
│   │   ├── programs/   # Desktop applications and CLI tools
│   │   ├── services/   # Background services (typically systemd)
│   │   ├── shared/     # Shared modules imported by every user and host
│   │   └── system/     # System-specific features (e.g., secure boot)
│   ├── profiles/       # Named feature categories to simplify imports
│   ├── systems/        # Host-specific configuration
│   └── users/          # User-specific configuration (user@host)
├── packages/           # Sources of custom packages (see features/packages)
├── secrets/            # Secrets (encrypted with SOPS via SSH keys)
├── CLAUDE.md           # Documentation for Claude (claude /init)
├── flake.nix           # Entry point: flake-parts + import-tree => modules
├── Justfile            # Recipes for common tasks (just --list)
└── statix.toml         # Custom linting rules for Statix
```

Every `.nix` file under `modules/` is a flake-parts module that registers features under `flake.modules.<class>.<aspect>`. A feature is a logical capability, implemented as either a single file or a directory of multiple files, and may also span multiple classes (`nixos`, `homeManager`, `darwin`). This is effectively a vertical slice architecture: each feature manages its full cross-class implementation in one place (also known as the dendritic pattern).

Systems and users compose configurations by importing features and profiles. Home Manager runs standalone, so the system and user configurations rebuild independently. See [CLAUDE.md](./CLAUDE.md) for terminology and conventions.
