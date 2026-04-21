{
  flake.modules.homeManager.sops = {pkgs, ...}: {
    home.packages = with pkgs; [
      sops
      ssh-to-age
    ];
  };
}
