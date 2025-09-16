{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.discord;
in {
  options.settings.programs.discord = {
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
