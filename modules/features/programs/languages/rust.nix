{
  flake.modules.homeManager.rust = {config, ...}: {
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
    };

    internal.persistence = {
      home.directories = [
        ".local/share/cargo"
      ];
    };
  };
}
