{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.settings.desktop.gnome;
in {
  options.settings.desktop.gnome.resources = {
    profilePicture = mkOption {
      description = "The path to the target profile picture.";
      type = types.path;
    };
    wallpaper = mkOption {
      description = "The path to the target wallpaper.";
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "centered";
        picture-uri = "file://" + cfg.resources.wallpaper;
        picture-uri-dark = "file://" + cfg.resources.wallpaper;
        primary-color = "#77767B";
        secondary-color = "#000000";
      };
    };

    home.file.".face".source = cfg.resources.profilePicture;
  };
}
