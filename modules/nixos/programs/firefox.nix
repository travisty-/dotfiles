{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.firefox;
in {
  options.settings.programs.firefox = {
    enable = mkEnableOption "Firefox";
  };

  # https://nixos.wiki/wiki/Firefox
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
