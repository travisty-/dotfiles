{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.desktop.hyprland;
in {
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent
  config = mkIf cfg.enable {
    services.hyprpolkitagent = {
      enable = true;
    };
  };
}
