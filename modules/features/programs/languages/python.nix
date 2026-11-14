{
  flake.modules.homeManager.python = {config, ...}: {
    home.sessionVariables = {
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
    };

    internal.persistence = {
      home.directories = [
        ".local/share/uv"
      ];
    };
  };
}
