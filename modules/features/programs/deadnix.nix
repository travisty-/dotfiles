{
  flake.modules.homeManager.deadnix = {pkgs, ...}: {
    home.packages = with pkgs; [
      deadnix
    ];
  };
}
