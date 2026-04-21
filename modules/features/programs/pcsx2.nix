{
  # https://nixos.wiki/wiki/Playstation2
  # https://wiki.nixos.org/wiki/PlayStation_2
  flake.modules.homeManager.pcsx2 = {pkgs, ...}: {
    home.packages = with pkgs; [
      pcsx2
    ];
  };
}
