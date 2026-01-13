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
        wallpaper = [
          {
            monitor = "";
            path = cfg.resources.wallpaper;
            fit_mode = "cover";
          }
        ];
        splash = false;
        ipc = true;
      };
    };
  };
}
