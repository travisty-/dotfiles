{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.deadnix;
in {
  options.settings.programs.deadnix = {
    enable = mkEnableOption "deadnix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      deadnix
    ];
  };
}
