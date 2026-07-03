{
  flake.modules.homeManager.chafa = {pkgs, ...}: {
    home.packages = with pkgs; [
      chafa
    ];
  };
}
