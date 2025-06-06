{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.remmina;
in {
  options.settings.programs.remmina = {
    enable = mkEnableOption "Remmina";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      remmina
    ];
  };
}
