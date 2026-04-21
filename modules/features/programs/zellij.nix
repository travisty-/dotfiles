{
  flake.modules.homeManager.zellij = {
    programs.zellij = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
  };
}
