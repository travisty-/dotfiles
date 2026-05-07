{
  flake.modules.homeManager.niri = {pkgs, ...}: {
    home.packages = with pkgs; [
      brightnessctl
      nautilus
      playerctl
    ];
  };
}
