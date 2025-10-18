{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.yq;
in {
  options.${namespace}.programs.yq = {
    enable = mkEnableOption "yq";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yq-go
    ];
  };
}
