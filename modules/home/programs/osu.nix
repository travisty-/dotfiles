{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.osu;
in {
  options.${namespace}.programs.osu = {
    enable = mkEnableOption "osu!";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      osu-lazer-bin
    ];
  };
}
