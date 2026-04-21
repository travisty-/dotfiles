{
  flake.modules.homeManager.base.nixpkgs.config.allowUnfree = true;
  flake.modules.nixos.base.nixpkgs.config.allowUnfree = true;
}
