{
  flake.modules.nixos.tailscale = {
    config,
    lib,
    ...
  }: let
    inherit (config.meta.user) username;
  in {
    services.tailscale.enable = true;
    services.tailscale.extraSetFlags = [
      "--operator=${username}"
    ];

    # Prevent tailscaled from auto-starting.
    systemd.services.tailscaled.wantedBy = lib.mkForce [];
    systemd.services.tailscaled-set.wantedBy = lib.mkForce [];
  };
}
