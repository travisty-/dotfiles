{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.powershell;
in {
  options.settings.programs.powershell = {
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
