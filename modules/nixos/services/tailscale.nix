{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.services.tailscale;
in {
  options.settings.services.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  # https://nixos.wiki/wiki/Tailscale
  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    services.tailscale.extraSetFlags = [
      "--operator=travis" # TODO
    ];
  };
}
