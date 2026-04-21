{
  flake.modules.homeManager.bind = {pkgs, ...}: {
    home.packages = with pkgs; [
      bind
    ];
  };
}
