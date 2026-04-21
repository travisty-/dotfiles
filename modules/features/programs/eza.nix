{
  flake.modules.homeManager.eza = {
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
