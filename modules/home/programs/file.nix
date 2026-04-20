{
  flake.modules.homeManager.file = {pkgs, ...}: {
    home.packages = with pkgs; [
      file
    ];
  };
}
