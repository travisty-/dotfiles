{
  flake.modules.homeManager.evince = {pkgs, ...}: {
    home.packages = with pkgs; [
      evince
    ];
  };
}
