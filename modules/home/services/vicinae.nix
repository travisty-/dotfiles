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
      settings = {
        faviconService = "twenty";
        font.size = 10.5;
        popToRootOnClose = true;
        rootSearch.searchFiles = false;
        theme.name = "vicinae-dark";
        window = {
          csd = true;
          opacity = 0.95;
          rounding = 10;
        };
      };
    };

    # Workaround to avoid creating a new backup every switch.
    xdg.configFile."vicinae/vicinae.json".force = true;
  };
}
