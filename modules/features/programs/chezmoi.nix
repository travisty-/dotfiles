{
  flake.modules.homeManager.chezmoi = {pkgs, ...}: {
    home.packages = with pkgs; [
      chezmoi
    ];
  };
}
