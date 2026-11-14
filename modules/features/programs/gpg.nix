{
  flake.modules.homeManager.gpg = {config, ...}: {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    internal.persistence = {
      home.directories = [
        {
          directory = ".local/share/gnupg";
          mode = "0700";
        }
      ];
    };
  };
}
