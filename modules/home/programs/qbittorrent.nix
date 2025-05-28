{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.qbittorrent;
in {
  options.settings.programs.qbittorrent = {
    enable = mkEnableOption "qBittorrent";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}
