{
  config,
  inputs,
  lib,
  ...
}:
with lib.extensions; {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home
  ];

  meta.user = {
    name = "Travis Kinney";
    email = "travis@traviskinney.co";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjX6MY8Lf61+1xzKMNqJKB2XtsF7/Q+PIBZuL6piWpQ";
    username = "travis";
  };

  # TODO: Remove generated key file in $XDG_RUNTIME_DIR/secrets.d
  # once sops-nix natively supports encryption/decryption via SSH.
  sops = {
    defaultSopsFile = ../../secrets/secrets.enc.yaml;
    age.sshKeyPaths = ["/home/travis/.ssh/id_ed25519"];
    validateSopsFiles = true;
  };

  settings = {
    desktop.hyprland = {
      enable = true;
      settings.monitors = [
        "DP-1, 3440x1440@175, 2560x0, 1, vrr, 3, bitdepth, 10"
        "DP-2, 2560x1440@144, 0x0, 1, vrr, 3, bitdepth, 10"
      ];
    };

    programs = {
      _1password = enabled;
      alacritty = enabled;
      anki = enabled;
      bind = enabled;
      chezmoi = enabled;
      claude-code = enabled;
      deadnix = enabled;
      devenv = enabled;
      direnv = enabled;
      discord = enabled;
      eza = enabled;
      fastfetch = enabled;
      fd = enabled;
      firefox = enabled;
      fzf = enabled;
      gh = enabled;
      ghostty = enabled;
      git = enabled;
      jq = enabled;
      just = enabled;
      mpv = enabled;
      neovim = enabled;
      nerd-fonts = enabled;
      obsidian = enabled;
      powershell = enabled;
      qbittorrent = enabled;
      remmina = enabled;
      ripgrep = enabled;
      sops = enabled;
      statix = enabled;
      subtitleedit = enabled;
      tmux = enabled;
      tree = enabled;
      vscode = enabled;
      yq = enabled;
      zellij = enabled;
      zoxide = enabled;
      zsh = enabled;
    };

    programs.gtk = {
      enable = true;
      bookmarks = [
        "file://${config.home.homeDirectory}/Documents"
        "file://${config.home.homeDirectory}/Downloads"
        "file://${config.home.homeDirectory}/Music"
        "file://${config.home.homeDirectory}/Pictures"
        "file://${config.home.homeDirectory}/Videos"
        "file:///media/data Media"
        "file:///media/games Games"
      ];
    };

    programs.jetbrains = {
      toolbox = disabled;
      datagrip = enabled;
      goland = enabled;
      pycharm = enabled;
      rider = enabled;
    };

    services = {
      hyprpolkitagent = enabled;
      swaync = enabled;
    };
  };
}
