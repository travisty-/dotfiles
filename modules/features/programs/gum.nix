{
  flake.modules.homeManager.gum = {pkgs, ...}: {
    home.packages = with pkgs; [
      gum
    ];
  };
}
