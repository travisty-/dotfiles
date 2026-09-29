{
  flake.modules.homeManager.rumdl = {pkgs, ...}: {
    home.packages = with pkgs; [
      rumdl
    ];

    xdg.configFile."rumdl/rumdl.toml" = {
      source = ./rumdl.toml;
    };
  };
}
