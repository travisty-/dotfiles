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
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      git = true;

      extraOptions = [
        "--color=always"
        "--group-directories-first"
        "--group"
      ];
    };

    home.shellAliases = {
      ls = "eza";
    };
  };
}
