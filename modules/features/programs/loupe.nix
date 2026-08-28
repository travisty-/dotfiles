{
  flake.modules.homeManager.loupe = {pkgs, ...}: {
    home.packages = with pkgs; [
      loupe
    ];

    xdg.mimeApps = {
      defaultApplicationPackages = with pkgs; [loupe];
    };
  };
}
