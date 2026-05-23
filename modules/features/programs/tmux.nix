{
  flake.modules.homeManager.tmux = {
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
    };
  };
}
