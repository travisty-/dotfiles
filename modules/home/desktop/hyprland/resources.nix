{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland.resources = {
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
