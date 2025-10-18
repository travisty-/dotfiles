{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.remmina;
in {
  options.${namespace}.programs.remmina = {
    enable = mkEnableOption "Remmina";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      remmina
    ];
  };
}
