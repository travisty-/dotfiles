{
  flake.modules.homeManager.hyprland = {
    lib,
    config,
    ...
  }: let
    inherit (lib) mkOption types;
    cfg = config.internal.desktop.hyprland;
  in {
    options.internal.desktop.hyprland.resources = {
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
      home.file.".face".source = cfg.resources.profilePicture;
    };
  };
}
