{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.firefox;
in {
  options.${namespace}.programs.firefox = {
    enable = mkEnableOption "Firefox";
  };

  # https://nixos.wiki/wiki/Firefox
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
