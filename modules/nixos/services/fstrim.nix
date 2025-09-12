{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.services.fstrim;
in {
  options.settings.services.fstrim = {
    enable = mkEnableOption "SSD TRIM";
  };

  # https://wiki.nixos.org/wiki/Filesystems
  config = mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}
