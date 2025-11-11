{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.coolercontrol;
in {
  options.${namespace}.programs.coolercontrol = {
    enable = mkEnableOption "CoolerControl";
  };

  # https://docs.coolercontrol.org/installation/nix.html
  config = mkIf cfg.enable {
    programs.coolercontrol = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      liquidctl
      lm_sensors
    ];
  };
}
