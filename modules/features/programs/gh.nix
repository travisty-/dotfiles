{
  flake.modules.homeManager.gh = {
    programs.gh = {
      enable = true;
    };

    internal.persistence = {
      home.directories = [
        ".config/gh"
      ];
    };
  };
}
