{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.devenv;
in {
  options.settings.programs.devenv = {
    enable = mkEnableOption "devenv";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      devenv
    ];
  };
}
