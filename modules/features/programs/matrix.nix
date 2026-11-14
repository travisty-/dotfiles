{
  flake.modules.homeManager.matrix = {
    programs.element-desktop = {
      enable = true;
    };

    internal.persistence = {
      home.directories = [
        ".config/Element"
      ];
    };
  };
}
