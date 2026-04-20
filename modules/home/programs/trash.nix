{
  flake.modules.homeManager.trash = {pkgs, ...}: {
    home.packages = with pkgs; [
      trash-cli
    ];
  };
}
