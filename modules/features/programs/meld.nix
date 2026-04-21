{
  flake.modules.homeManager.meld = {pkgs, ...}: {
    home.packages = with pkgs; [
      meld
    ];
  };
}
