{
  flake.modules.homeManager.anki = {
    programs.anki = {
      enable = true;
    };

    internal.persistence = {
      home.directories = [
        ".local/share/Anki2"
      ];
    };
  };
}
