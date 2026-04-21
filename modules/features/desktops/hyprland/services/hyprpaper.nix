{
  flake.modules.homeManager.hyprland = {config, ...}: let
    cfg = config.internal.desktop.hyprland;
  in {
    config = {
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
  };
}
