{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.fstrim;
in {
  options.${namespace}.services.fstrim = {
    enable = mkEnableOption "SSD TRIM";
  };

  # https://wiki.nixos.org/wiki/Filesystems
  config = mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}
