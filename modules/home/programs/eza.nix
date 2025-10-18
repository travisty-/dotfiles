{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.eza;
in {
  options.${namespace}.programs.eza = {
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
