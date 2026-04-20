{
  flake.modules.homeManager.papers = {pkgs, ...}: {
    home.packages = with pkgs; [
      papers
    ];
  };
}
