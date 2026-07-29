{
  flake.modules.homeManager.rumdl = {pkgs, ...}: {
    home.packages = with pkgs; [
      rumdl
    ];
  };
}
