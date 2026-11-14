{
  flake.modules.homeManager.nushell = {pkgs, ...}: {
    programs.nushell = {
      enable = true;
      plugins = with pkgs.nushellPlugins; [
        formats
        query
      ];
    };

    internal.persistence = {
      home.directories = [
        ".config/nushell"
        ".local/share/nushell"
      ];
    };
  };
}
