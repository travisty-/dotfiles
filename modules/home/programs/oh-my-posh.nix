{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.oh-my-posh;
in {
  options.settings.programs.oh-my-posh = {
    enable = mkEnableOption "Oh My Posh";
  };

  config = mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableNushellIntegration = false;
      enableZshIntegration = false;
    };

    home.sessionVariables = {
      POSH_THEMES_PATH = "${pkgs.oh-my-posh}/share/oh-my-posh/themes";
    };
  };
}
