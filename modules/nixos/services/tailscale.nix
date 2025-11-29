{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.meta.user) username;
  cfg = config.${namespace}.services.tailscale;
in {
  options.${namespace}.services.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  # https://nixos.wiki/wiki/Tailscale
  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    services.tailscale.extraSetFlags = [
      "--operator=${username}"
    ];

    # Prevent tailscaled from auto-starting.
    systemd.services.tailscaled.wantedBy = lib.mkForce [];
    systemd.services.tailscaled-set.wantedBy = lib.mkForce [];
  };
}
