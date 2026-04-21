{
  flake.modules.homeManager.alacritty = {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
      };
    };
  };
}
