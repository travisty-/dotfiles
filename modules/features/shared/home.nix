{
  flake.modules.homeManager.base = {config, ...}: let
    inherit (config.meta) user;
  in {
    # Home Manager needs a bit of information about you and the paths it should manage.
    home.username = user.username;
    home.homeDirectory = "/home/${user.username}";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
