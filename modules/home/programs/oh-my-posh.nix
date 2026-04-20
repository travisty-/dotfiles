{
  flake.modules.homeManager.oh-my-posh = {pkgs, ...}: {
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
