{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.eza;
in {
  options.settings.programs.eza = {
    enable = mkEnableOption "eza";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
      ];
    };

    home.shellAliases = {
      ls = "eza";
    };
  };
}
