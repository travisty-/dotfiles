{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.hardware.xpadneo;
in {
  options.settings.hardware.xpadneo = {
    enable = mkEnableOption "xpadneo";
  };

  config = mkIf cfg.enable {
    hardware.xpadneo.enable = true;
  };
}
