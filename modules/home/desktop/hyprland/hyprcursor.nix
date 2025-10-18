{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.desktop.hyprland;
in {
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprcursor
  config = mkIf cfg.enable {
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      hyprcursor.enable = true;
      package = pkgs.rose-pine-hyprcursor;
      name = "rose-pine-hyprcursor";
    };
  };
}
