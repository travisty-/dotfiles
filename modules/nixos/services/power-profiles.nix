{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.power-profiles;
in {
  options.${namespace}.services.power-profiles = {
    enable = mkEnableOption "Power Profiles Daemon";
  };

  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;
  };
}
