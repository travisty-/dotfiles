{
  flake.modules.homeManager.just = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      just
    ];

    home.shellAliases = {
      gust = "just --global-justfile";
    };

    xdg.configFile."just/Justfile" = {
      source = pkgs.replaceVars ./Justfile {
        flake = config.meta.flake;
      };
    };
  };
}
