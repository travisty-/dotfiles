{
  flake.modules.homeManager.qbittorrent = {pkgs, ...}: {
    nixpkgs.overlays = [
      (import ../../../overlays/qbittorrent.nix)
    ];

    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}
