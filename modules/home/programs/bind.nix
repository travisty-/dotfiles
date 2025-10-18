{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.bind;
in {
  options.${namespace}.programs.bind = {
    enable = mkEnableOption "BIND 9";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bind
    ];
  };
}
