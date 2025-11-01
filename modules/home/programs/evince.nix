{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.evince;
in {
  options.${namespace}.programs.evince = {
    enable = mkEnableOption "Evince (GNOME Document Viewer)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      evince
    ];
  };
}
