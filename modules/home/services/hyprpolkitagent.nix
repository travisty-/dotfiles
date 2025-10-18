{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.hyprpolkitagent;
in {
  options.${namespace}.services.hyprpolkitagent = {
    enable = mkEnableOption "hyprpolkitagent";
  };

  # https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent
  config = mkIf cfg.enable {
    services.hyprpolkitagent = {
      enable = true;
    };
  };
}
