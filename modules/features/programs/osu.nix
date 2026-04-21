{
  flake.modules.homeManager.osu = {pkgs, ...}: {
    home.packages = with pkgs; [
      osu-lazer-bin
    ];
  };
}
