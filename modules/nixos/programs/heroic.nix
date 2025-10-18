{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.heroic;
in {
  options.${namespace}.programs.heroic = {
    enable = mkEnableOption "Heroic Games Launcher";
  };

  # https://wiki.nixos.org/wiki/Heroic_Games_Launcher
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamemode
          pkgs.gamescope
        ];
      })
    ];
  };
}
