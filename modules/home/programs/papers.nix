{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.papers;
in {
  options.${namespace}.programs.papers = {
    enable = mkEnableOption "Papers (GNOME Document Viewer)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      papers
    ];
  };
}
