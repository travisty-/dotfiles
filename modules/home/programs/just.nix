{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.just;
in {
  options.${namespace}.programs.just = {
    enable = mkEnableOption "just";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      just
    ];
  };
}
