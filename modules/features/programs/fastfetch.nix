{
  flake.modules.homeManager.fastfetch = {
    programs.fastfetch = {
      enable = true;
    };

    home.shellAliases = {
      ff = "fastfetch";
    };
  };
}
