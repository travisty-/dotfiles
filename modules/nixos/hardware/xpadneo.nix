{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.hardware.xpadneo;
in {
  options.${namespace}.hardware.xpadneo = {
    enable = mkEnableOption "xpadneo";
  };

  config = mkIf cfg.enable {
    hardware.xpadneo.enable = true;
  };
}
