# Dendritic Roadmap

Things to do after the initial migration.

## Cross-cutting modules

Some modules are split across `nixos/` and `home/` (e.g., `nixos/programs/firefox.nix` and `home/programs/firefox.nix`). These could be merged into single files with both `flake.modules.nixos` and `flake.modules.homeManager` aspects.

About half of the dendritic configs I looked at do this, the other half keep them split. Worth trying with firefox and 1password first to see which style I prefer. gnome and hyprland are also candidates.

## Profiles

_Name subject to change, possibly components?_

Define profile modules that group related features into a single import. Useful when adding a second system so I don't end up duplicating the full import list.

Thoughts for groupings:

- cli: zsh, oh-my-posh, eza, fd, fzf, ripgrep, jq, yq, btop, fastfetch, file, bind, tree, trash, zoxide
- development: git, gh, lazygit, meld, helix, neovim, vscode, jetbrains, direnv, devenv, claude-code, deadnix, statix, just
- terminal: ghostty, alacritty, tmux, zellij
- desktop: hyprland, waybar, wlogout, swaync, gtk, vicinae, nerd-fonts, xorg
- media: mpv, qbittorrent, subtitleedit
- gaming: steam, heroic, lutris, bottles, minecraft, osu, pcsx2
- communication: discord, matrix
- productivity: firefox, obsidian, papers, anki, evince, remmina

Not grouped (import individually):

- _1password, sops: security, keep explicit
- solaar: Logitech-specific hardware
- chezmoi: migration tool, might remove
- powershell: not needed on every system

### Tag-based profiles (future)

Instead of manually listing modules in each profile, modules could self-declare their tags:

```nix
# modules/programs/btop.nix
{
  tags = ["cli"];

  flake.modules.homeManager.btop = {
    programs.btop.enable = true;
  };
}
```

A resolver would then collect all modules with a given tag into a profile automatically. Adding a new module with a tag would include it everywhere that tag is used.

Trade-off: you can't see what's in a profile by reading just the profile file.

Open questions:

- How to define the `tags` option and the resolver infrastructure
- Whether tags should be per-class (`tags.homeManager = ["cli"]`) or flat (`tags = ["cli"]`)

## nixos-facter

Replace `hardware-configuration.nix` with nixos-facter's `facter.json`. Several dendritic configs use this (mightyiam, drupol, quasigod). Avoids having to manually maintain a generated file.

## Colocate static files

Move config files out of `files/` and put them next to their modules. For example, mpv config would live next to `modules/home/programs/mpv.nix` instead of in `files/config/mpv/`.

## Inline overlays

Move the overlay files from `overlays/` into the modules that use them (qbittorrent, spotify, pop-shell).

## Known issues

### Dead code in configuration.nix

`modules/hosts/earth/_config/configuration.nix` sets `boot.loader.systemd-boot.enable = true`, but secure-boot force-overrides it.

### Hardcoded `/etc/nixos/` paths

mpv and jetbrains modules hardcode `/etc/nixos/...` in `mkOutOfStoreSymlink` calls. Could add a `meta.repoPath` option set once in the user module.


