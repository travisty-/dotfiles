{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.bind;
in {
  options.settings.programs.bind = {
    enable = mkEnableOption "BIND 9";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bind
    ];
  };
}
