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
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpicker
      hyprshot
      hyprsysteminfo
    ];
  };
}
