{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.trash;
in {
  options.settings.programs.trash = {
    enable = mkEnableOption "trash-cli";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      trash-cli
    ];
  };
}
