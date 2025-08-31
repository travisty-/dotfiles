{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.xorg;
in {
  options.settings.programs.xorg = {
    enable = mkEnableOption "Xorg helpers";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xorg.xeyes
      xorg.xlsclients
      xorg.xrandr
    ];
  };
}
