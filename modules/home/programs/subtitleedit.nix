{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.subtitleedit;
in {
  options.settings.programs.subtitleedit = {
    enable = mkEnableOption "Subtitle Edit";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      subtitleedit
    ];
  };
}
