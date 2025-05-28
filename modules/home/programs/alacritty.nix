{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.alacritty;
in {
  options.settings.programs.alacritty = {
    enable = mkEnableOption "Alacritty";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
      };
    };
  };
}
