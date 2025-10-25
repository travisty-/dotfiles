{
  config,
  lib,
  namespace,
  pkgs,
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

    home.packages = with pkgs; [
      libnotify
    ];
  };
}
