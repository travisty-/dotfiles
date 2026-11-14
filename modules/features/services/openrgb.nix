{
  flake.modules.nixos.openrgb = {pkgs, ...}: {
    services.hardware.openrgb.enable = true;
    services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;

    internal.persistence = {
      home.directories = [
        ".config/OpenRGB"
      ];
      root.directories = [
        "/var/lib/OpenRGB"
      ];
    };
  };
}
