{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home/alacritty.nix
    ../../modules/home/eza.nix
    ../../modules/home/fd.nix
    ../../modules/home/fzf.nix
    ../../modules/home/git.nix
    ../../modules/home/ripgrep.nix
    ../../modules/home/zoxide.nix
    ../../modules/home/zsh.nix
  ];

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
