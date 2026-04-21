{
  flake.modules.homeManager.statix = {pkgs, ...}: {
    home.packages = with pkgs; [
      statix
    ];
  };
}
