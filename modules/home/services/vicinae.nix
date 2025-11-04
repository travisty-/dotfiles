{
  config,
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.vicinae;
in {
  options.${namespace}.services.vicinae = {
    enable = mkEnableOption "Vicinae";
  };

  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  # https://docs.vicinae.com/nixos
  config = mkIf cfg.enable {
    services.vicinae = {
      enable = true;
      autoStart = true;
    };
  };
}
