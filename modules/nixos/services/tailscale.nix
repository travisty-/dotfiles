{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.tailscale;
in {
  options.${namespace}.services.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  # https://nixos.wiki/wiki/Tailscale
  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    services.tailscale.extraSetFlags = [
      "--operator=travis" # TODO
    ];

    # Prevent tailscaled from auto-starting.
    systemd.services.tailscaled.wantedBy = lib.mkForce [];
  };
}
