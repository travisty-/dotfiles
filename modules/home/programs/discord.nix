{
  config,
  lib,
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
    programs.vesktop = {
      enable = true;
    };
  };
}
