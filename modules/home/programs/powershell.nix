{
  flake.modules.homeManager.powershell = {pkgs, ...}: {
    home.packages = with pkgs; [
      powershell
    ];

    xdg.configFile."powershell/profile.ps1" = {
      source = ../../../files/config/powershell/profile.ps1;
    };
  };
}
