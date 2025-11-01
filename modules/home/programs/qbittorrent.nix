{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.qbittorrent;
in {
  options.${namespace}.programs.qbittorrent = {
    enable = mkEnableOption "qBittorrent";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (import ../../../overlays/qbittorrent.nix)
    ];

    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}
