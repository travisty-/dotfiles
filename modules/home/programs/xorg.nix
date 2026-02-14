{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.xorg;
in {
  options.${namespace}.programs.xorg = {
    enable = mkEnableOption "Xorg helpers";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xeyes
      xlsclients
      xrandr
    ];
  };
}
