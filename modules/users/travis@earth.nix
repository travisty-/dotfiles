{inputs, ...}: {
  flake.modules.homeManager."travis@earth" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      base
      hyprland
      _1password
      alacritty
      anki
      bind
      btop
      chezmoi
      claude-code
      deadnix
      devenv
      direnv
      discord
      evince
      eza
      fastfetch
      fd
      file
      firefox
      fzf
      gh
      ghostty
      git
      gtk
      helix
      jetbrains
      jq
      just
      lazygit
      matrix
      meld
      minecraft
      mpv
      neovim
      nerd-fonts
      obsidian
      oh-my-posh
      osu
      papers
      pcsx2
      powershell
      qbittorrent
      remmina
      ripgrep
      solaar
      sops
      statix
      subtitleedit
      swaync
      tmux
      trash
      tree
      vscode
      waybar
      wlogout
      xorg
      yq
      zellij
      zoxide
      zsh
      vicinae
    ];

    meta.user = {
      name = "Travis Kinney";
      email = "travis@traviskinney.co";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjX6MY8Lf61+1xzKMNqJKB2XtsF7/Q+PIBZuL6piWpQ";
      username = "travis";
    };

    sops = {
      defaultSopsFile = ../../secrets/secrets.enc.yaml;
      validateSopsFiles = true;

      # An empty string bypasses ssh-to-age key conversion in sops-install-secrets.
      # Temporary workaround to avoid generating intermediate age-keys.txt files
      # until sops-nix natively supports SSH keys. (sops-nix#695, sops-nix#824)
      age.keyFile = "";
      environment = {
        SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };

    internal.desktop.hyprland = {
      resources = {
        profilePicture = ../../files/images/crying-bear.png;
        wallpaper = "${inputs.wallpapers}/3440x1440/isometric-grid-mono.png";
      };
      settings.monitors = [
        "DP-1, 3440x1440@175, 2560x0, 1, vrr, 3, bitdepth, 10"
        "DP-2, 2560x1440@144, 0x0, 1, vrr, 3, bitdepth, 10"
      ];
    };

    internal.programs.gtk.bookmarks = [
      "file://${config.home.homeDirectory}/Documents"
      "file://${config.home.homeDirectory}/Downloads"
      "file://${config.home.homeDirectory}/Music"
      "file://${config.home.homeDirectory}/Pictures"
      "file://${config.home.homeDirectory}/Videos"
      "file:///media/data Media"
      "file:///media/games Games"
    ];

    internal.programs.jetbrains = {
      toolbox.enable = false;
      datagrip.enable = true;
      goland.enable = true;
      pycharm.enable = true;
      rider.enable = true;
      rustrover.enable = true;
    };
  };

  flake.homeConfigurations = inputs.self.lib.mkHome "x86_64-linux" "travis@earth";
}
