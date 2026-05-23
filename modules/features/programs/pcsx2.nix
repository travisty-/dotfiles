{
  flake.modules.homeManager.pcsx2 = {pkgs, ...}: {
    home.packages = with pkgs; [
      pcsx2
    ];
  };
}
