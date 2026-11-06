{
  flake.modules.homeManager.dust = {pkgs, ...}: {
    home.packages = with pkgs; [
      dust
    ];
  };
}
