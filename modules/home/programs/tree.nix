{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.tree;
in {
  options.settings.programs.tree = {
    enable = mkEnableOption "tree";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tree
    ];
  };
}
