{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.spotify;
in {
  options.settings.programs.spotify = {
    enable = mkEnableOption "Spotify";
  };

  # https://nixos.wiki/wiki/Spotify
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotify
    ];

    # Allow syncing local tracks with mobile devices in the same network.
    networking.firewall.allowedTCPPorts = [57621];

    # Allow discovery of Google Cast devices (and possibly
    # other Spotify Connect devices) in the same network.
    networking.firewall.allowedUDPPorts = [5353];
  };
}
