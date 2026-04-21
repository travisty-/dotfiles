{
  flake.modules.homeManager.gnome = {
    config,
    lib,
    ...
  }: let
    inherit (lib) mkOption types;
    cfg = config.internal.desktop.gnome;
  in {
    options.internal.desktop.gnome.resources = {
      monitors = mkOption {
        description = "The path to the target monitor configuration file.";
        type = types.path;
      };
      profilePicture = mkOption {
        description = "The path to the target profile picture.";
        type = types.path;
      };
      wallpaper = mkOption {
        description = "The path to the target wallpaper.";
        type = types.path;
      };
    };

    config = {
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

      xdg.configFile."monitors.xml".source = cfg.resources.monitors;
    };
  };
}
