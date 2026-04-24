{
  flake.modules.homeManager.nix-update = {pkgs, ...}: {
    home.packages = with pkgs; [
      nix-update
    ];
  };
}
