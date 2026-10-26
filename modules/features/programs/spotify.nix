{
  flake.modules.homeManager.spotify = {pkgs, ...}: {
    home.packages = with pkgs; [
      spotify
    ];
  };

  flake.modules.nixos.spotify = {
    # Allow syncing local tracks with mobile devices in the same network.
    networking.firewall.allowedTCPPorts = [57621];

    # Allow discovery of Google Cast devices (and possibly
    # other Spotify Connect devices) in the same network.
    networking.firewall.allowedUDPPorts = [5353];
  };
}
