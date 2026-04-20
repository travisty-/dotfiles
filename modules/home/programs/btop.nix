{
  flake.modules.homeManager.btop = {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
        truecolor = true;
        vim_keys = true;
      };
    };
  };
}
