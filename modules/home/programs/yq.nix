{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.yq;
in {
  options.settings.programs.yq = {
    enable = mkEnableOption "yq";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yq-go
    ];
  };
}
