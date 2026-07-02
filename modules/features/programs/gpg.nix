{
  flake.modules.homeManager.gpg = {config, ...}: {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
  };
}
