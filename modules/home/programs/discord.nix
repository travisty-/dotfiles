{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.discord;
in {
  options.${namespace}.programs.discord = {
    enable = mkEnableOption "Discord";
  };

  # https://nixos.wiki/wiki/Discord
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];

    programs.vesktop = {
      enable = true;
    };
  };
}
