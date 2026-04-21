{
  flake.modules.homeManager.subtitleedit = {pkgs, ...}: {
    home.packages = with pkgs; [
      subtitleedit
    ];
  };
}
