{
  flake.modules.homeManager.qt = {
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "adwaita-dark";
    };
  };
}
