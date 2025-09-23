{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.solaar;
in {
  options.settings.programs.solaar = {
    enable = mkEnableOption "Solaar";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      solaar
    ];
  };
}
