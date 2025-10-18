{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.tree;
in {
  options.${namespace}.programs.tree = {
    enable = mkEnableOption "tree";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tree
    ];
  };
}
