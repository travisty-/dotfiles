{
  flake.modules.homeManager.bottom = {
    programs.bottom = {
      enable = true;
    };

    internal.persistence = {
      home.directories = [
        ".config/bottom"
      ];
    };
  };
}
