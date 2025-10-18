{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.trash;
in {
  options.${namespace}.programs.trash = {
    enable = mkEnableOption "trash-cli";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      trash-cli
    ];
  };
}
