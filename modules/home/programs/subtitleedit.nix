{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.subtitleedit;
in {
  options.${namespace}.programs.subtitleedit = {
    enable = mkEnableOption "Subtitle Edit";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      subtitleedit
    ];
  };
}
