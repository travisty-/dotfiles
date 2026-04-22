{
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  # https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  flake.modules.homeManager.base.home.stateVersion = "26.05";
  flake.modules.nixos.base.system.stateVersion = "26.05";
}
