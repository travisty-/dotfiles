{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.statix;
in {
  options.${namespace}.programs.statix = {
    enable = mkEnableOption "statix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      statix
    ];
  };
}
