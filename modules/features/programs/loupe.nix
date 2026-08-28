{
  flake.modules.homeManager.loupe = {pkgs, ...}: {
    home.packages = with pkgs; [
      loupe
    ];
  };
}
