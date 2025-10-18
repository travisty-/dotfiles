{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.deadnix;
in {
  options.${namespace}.programs.deadnix = {
    enable = mkEnableOption "deadnix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      deadnix
    ];
  };
}
