{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.just;
in {
  options.settings.programs.just = {
    enable = mkEnableOption "just";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      just
    ];
  };
}
