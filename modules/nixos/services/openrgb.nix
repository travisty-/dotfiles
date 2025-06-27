{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.services.openrgb;
in {
  options.settings.services.openrgb = {
    enable = mkEnableOption "OpenRGB";
  };

  # https://nixos.wiki/wiki/OpenRGB
  # https://wiki.nixos.org/wiki/OpenRGB
  config = mkIf cfg.enable {
    services.hardware.openrgb.enable = true;
    services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;
  };
}
