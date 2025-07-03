{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.chezmoi;
in {
  options.settings.programs.chezmoi = {
    enable = mkEnableOption "Chezmoi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chezmoi
    ];
  };
}
