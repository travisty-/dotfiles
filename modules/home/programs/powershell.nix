{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.powershell;
in {
  options.${namespace}.programs.powershell = {
    enable = mkEnableOption "PowerShell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      powershell
    ];

    xdg.configFile."powershell/profile.ps1" = {
      source = ../../../files/config/powershell/profile.ps1;
    };
  };
}
