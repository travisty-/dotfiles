{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.solaar;
in {
  options.${namespace}.programs.solaar = {
    enable = mkEnableOption "Solaar";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      solaar
    ];
  };
}
