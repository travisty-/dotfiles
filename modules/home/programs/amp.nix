{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.amp;
in {
  options.${namespace}.programs.amp = {
    enable = mkEnableOption "Amp";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      amp-cli
    ];
  };
}
