{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };

    internal.persistence = {
      home.directories = [
        ".local/share/direnv"
      ];
    };
  };
}
