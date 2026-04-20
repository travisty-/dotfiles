{
  # https://nixos.wiki/wiki/Tmux
  flake.modules.homeManager.tmux = {
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
    };
  };
}
