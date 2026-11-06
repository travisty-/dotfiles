{
  flake.modules.homeManager.btop = {pkgs, ...}: {
    programs.btop = {
      enable = true;
      package = pkgs.btop-cuda;
      settings = {
        color_theme = "Default";
        cpu_sensor = "k10temp/Tctl";
        shown_boxes = "cpu mem net proc gpu0";
        theme_background = false;
        truecolor = true;
        vim_keys = true;
      };
    };
  };
}
