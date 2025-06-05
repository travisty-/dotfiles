{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.lutris;
in {
  options.settings.programs.lutris = {
    enable = mkEnableOption "Lutris";
  };

  # https://nixos.wiki/wiki/Lutris
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
