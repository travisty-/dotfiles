{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.fd;
in {
  options.settings.programs.fd = {
    enable = mkEnableOption "fd";
  };

  config = mkIf cfg.enable {
    programs.fd = {
      enable = true;
    };
  };
}
