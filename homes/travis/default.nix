_: {
  imports = [
    ../../modules/home
  ];

  settings = {
    desktop = {
      gnome.enable = true;

      gnome.resources = {
        profilePicture = ../../files/images/crying-bear.png;
        wallpaper = ../../files/wallpapers/medusa.png;
      };
    };

    programs = {
      _1password.enable = true;
      alacritty.enable = true;
      deadnix.enable = true;
      devenv.enable = true;
      direnv.enable = true;
      discord.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fd.enable = true;
      fzf.enable = true;
      ghostty.enable = true;
      gh.enable = true;
      git.enable = true;
      just.enable = true;
      mpv.enable = true;
      obsidian.enable = true;
      powershell.enable = true;
      qbittorrent.enable = true;
      ripgrep.enable = true;
      remmina.enable = true;
      statix.enable = true;
      vscode.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "travis";
  home.homeDirectory = "/home/travis";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes. You should not change this value,
  # even if you update Home Manager. If you do want to update the value, then
  # make sure to first check the Home Manager release notes.
  home.stateVersion = "25.11";
}
