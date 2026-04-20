{
  # https://nixos.wiki/wiki/OpenRGB
  # https://wiki.nixos.org/wiki/OpenRGB
  flake.modules.nixos.openrgb = {pkgs, ...}: {
    services.hardware.openrgb.enable = true;
    services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;
  };
}
