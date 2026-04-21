{
  # https://nixos.wiki/wiki/Matrix
  flake.modules.homeManager.matrix = {
    programs.element-desktop = {
      enable = true;
    };
  };
}
