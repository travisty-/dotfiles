{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.services.swaync;
in {
  options.settings.services.swaync = {
    enable = mkEnableOption "Sway Notification Center";
  };

  config = mkIf cfg.enable {
    services.swaync = {
      enable = true;
    };
  };
}
