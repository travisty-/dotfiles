{
  flake.modules.homeManager.base = {config, ...}: {
    xdg = {
      enable = true;
      mimeApps.enable = true;
    };

    # XDG environment variables for development tools.
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
      GOPATH = "${config.xdg.dataHome}/go";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    };
  };
}
