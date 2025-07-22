{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.services.hyprpolkitagent;
in {
  options.settings.services.hyprpolkitagent = {
    enable = mkEnableOption "hyprpolkitagent";
  };

  # https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent
  config = mkIf cfg.enable {
    services.hyprpolkitagent = {
      enable = true;
    };
  };
}
