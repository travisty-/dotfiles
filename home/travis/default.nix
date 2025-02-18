{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home
  ];

  settings = {
    desktop = {
      gnome.enable = true;
    };

    programs = {
      alacritty.enable = true;
      eza.enable = true;
      fd.enable = true;
      fzf.enable = true;
      ghostty.enable = true;
      git.enable = true;
      powershell.enable = true;
      ripgrep.enable = true;
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
  home.stateVersion = "24.11";
}
