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

- Module system via [`flake-parts`][1] and [`import-tree`][2]
- Disk partitioning via [`disko`](https://github.com/nix-community/disko)
- Hardware detection via [`nixos-facter`](https://github.com/nix-community/nixos-facter)
- Pre-commit hooks via [`git-hooks.nix`](https://github.com/cachix/git-hooks.nix)
- Formatting (tree) via [`treefmt-nix`](https://github.com/numtide/treefmt-nix)
- Scheduled backups via [`restic`](https://github.com/restic/restic)
- Secret management via [`sops-nix`](https://github.com/Mic92/sops-nix)
- Secure boot via [`lanzaboote`](https://github.com/nix-community/lanzaboote)

[1]: https://github.com/hercules-ci/flake-parts
[2]: https://github.com/vic/import-tree

[^1]: Configuration in [travisty-/neovim](https://github.com/travisty-/neovim).

## Overview

```text
.
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
│   ├── profiles/       # Collections of features to simplify imports
│   ├── systems/        # Host-specific configuration
│   └── users/          # User-specific configuration (user@host)
├── packages/           # Sources of custom packages (see features/packages)
├── secrets/            # Secrets (encrypted with SOPS via SSH keys)
├── CLAUDE.md           # Documentation for Claude (claude /init)
├── flake.nix           # Entry point: flake-parts + import-tree => modules
└── Justfile            # Recipes for common tasks (just --list)
```
