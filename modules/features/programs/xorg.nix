{
  flake.modules.homeManager.xorg = {pkgs, ...}: {
    home.packages = with pkgs; [
      xeyes
      xlsclients
      xrandr
    ];
  };
}
