{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = ["${cfg.resources.wallpaper}"];
        wallpaper = [", ${cfg.resources.wallpaper}"];
        splash = false;
        ipc = "on";
      };
    };
  };
}
