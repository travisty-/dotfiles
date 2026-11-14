{
  flake.modules.homeManager.go = {config, ...}: {
    home.sessionVariables = {
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
      GOPATH = "${config.xdg.dataHome}/go";
    };

    xdg.configFile."go/telemetry/mode".text = "off";

    internal.persistence = {
      home.directories = [
        ".cache/go"
        ".local/share/go"
      ];
    };
  };
}
