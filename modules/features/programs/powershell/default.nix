{
  flake.modules.homeManager.powershell = {pkgs, ...}: {
    home.packages = with pkgs; [
      powershell
    ];

    xdg.configFile."powershell/profile.ps1" = {
      source = ./profile.ps1;
    };
  };
}
