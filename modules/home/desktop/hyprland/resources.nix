{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.settings.desktop.hyprland;
in {
  options.settings.desktop.hyprland.resources = {
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
    home.file.".face".source = cfg.resources.profilePicture;
  };
}
