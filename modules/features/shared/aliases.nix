{
  flake.modules.homeManager.base = {
    home.shellAliases = {
      cdtemp = "cd $(mktemp -d)";
    };
  };
}
