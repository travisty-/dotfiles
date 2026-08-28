{
  flake.modules.homeManager.papers = {pkgs, ...}: {
    home.packages = with pkgs; [
      papers
    ];

    xdg.mimeApps = {
      defaultApplicationPackages = with pkgs; [papers];
    };
  };
}
