{
  flake.modules.homeManager.base = {config, ...}: {
    xdg = {
      enable = true;
      mimeApps.enable = true;
    };

    # User-specific executables (XDG Base Directory Specification 0.8+).
    home.sessionPath = ["$HOME/.local/bin"];

    # XDG environment variables for development tools.
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
      GOPATH = "${config.xdg.dataHome}/go";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    };
  };
}
