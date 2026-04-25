{inputs, ...}: {
  flake.modules.homeManager."travis@earth" = {config, ...}: {
    imports =
      (with inputs.self.profiles.homeManager; [
        desktop
        gaming
      ])
      ++ (with inputs.self.modules.homeManager; [
        base
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
        evince
        eza
        fastfetch
        fd
        file
        firefox
        fish
        fzf
        gh
        ghostty
        git
        helix
        jetbrains
        jq
        just
        lazygit
        matrix
        meld
        mpv
        neovim
        nix-update
        obsidian
        oh-my-posh
        papers
        powershell
        qbittorrent
        raindrop
        remmina
        ripgrep
        solaar
        sops
        statix
        subtitleedit
        tmux
        trash
        tree
        vscode
        yq
        zellij
        zoxide
        zsh
      ]);

    meta.user = {
      name = "Travis Kinney";
      email = "travis@traviskinney.co";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjX6MY8Lf61+1xzKMNqJKB2XtsF7/Q+PIBZuL6piWpQ";
      username = "travis";
    };

    internal.desktops.hyprland = {
      resources = {
        profilePicture = ./profile-picture.png;
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

  flake.homeConfigurations = inputs.self.lib.mkHome "travis@earth" "x86_64-linux";
}
