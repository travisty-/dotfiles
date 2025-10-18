{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.swaync;
in {
  options.${namespace}.services.swaync = {
    enable = mkEnableOption "Sway Notification Center";
  };

  config = mkIf cfg.enable {
    services.swaync = {
      enable = true;
    };
  };
}
