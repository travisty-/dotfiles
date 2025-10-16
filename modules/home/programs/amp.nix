{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.amp;
in {
  options.settings.programs.amp = {
    enable = mkEnableOption "Amp";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      amp-cli
    ];
  };
}
