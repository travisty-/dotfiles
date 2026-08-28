{inputs, ...}: {
  flake.modules.homeManager."travis@earth" = {config, ...}: {
    imports =
      (with inputs.self.profiles.homeManager; [
        cli
        desktop
        development
        gaming
        media
        productivity
        shell
      ])
      ++ (with inputs.self.modules.homeManager; [
        base
        _1password
        firefox
        gpg
        loupe
        matrix
        meld
        papers
        remmina
        solaar
        vim
      ]);

    meta.user = {
      name = "Travis Kinney";
      email = "travis@traviskinney.co";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjX6MY8Lf61+1xzKMNqJKB2XtsF7/Q+PIBZuL6piWpQ";
      username = "travis";
    };

    internal.desktops.niri = {
      profilePicture = ./profile-picture.png;
      outputs = {
        primary = {
          name = "DP-1";
          mode = {
            width = 3440;
            height = 1440;
            refresh = 174.963;
          };
          position = {
            x = 2560;
            y = 0;
          };
          focus-at-startup = true;
          variable-refresh-rate = "on-demand"; # true
        };
        secondary = {
          name = "DP-2";
          mode = {
            width = 2560;
            height = 1440;
            refresh = 143.964;
          };
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = "on-demand"; # true
        };
      };
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
