{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.lutris;
in {
  options.${namespace}.programs.lutris = {
    enable = mkEnableOption "Lutris";
  };

  # https://nixos.wiki/wiki/Lutris
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
