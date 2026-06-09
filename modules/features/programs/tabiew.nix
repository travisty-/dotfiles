{
  flake.modules.homeManager.tabiew = {pkgs, ...}: {
    home.packages = with pkgs; [
      tabiew
    ];
  };
}
