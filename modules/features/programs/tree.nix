{
  flake.modules.homeManager.tree = {pkgs, ...}: {
    home.packages = with pkgs; [
      tree
    ];
  };
}
