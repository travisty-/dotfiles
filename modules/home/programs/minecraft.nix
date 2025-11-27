{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.minecraft;
in {
  options.${namespace}.programs.minecraft = {
    enable = mkEnableOption "Minecraft";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
