{
  flake.modules.homeManager.qt = {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };
  };
}
