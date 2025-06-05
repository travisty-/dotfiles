{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.statix;
in {
  options.settings.programs.statix = {
    enable = mkEnableOption "statix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      statix
    ];
  };
}
