{
  flake.modules.homeManager.clipboard = {pkgs, ...}: {
    home.packages = with pkgs; [
      # cliphist
      wl-clipboard
      wl-clip-persist
    ];
  };
}
