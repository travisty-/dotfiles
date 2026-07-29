{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit.settings.hooks = {
      deadnix.enable = true;
      statix = {
        enable = true;
        settings.config = "${inputs.self}/statix.toml";
      };
      treefmt = {
        enable = true;
        package = config.treefmt.build.wrapper;
      };
    };

    devShells.default = pkgs.mkShell {
      inherit (config.pre-commit) shellHook;
      packages =
        config.pre-commit.settings.enabledPackages
        ++ [pkgs.just config.treefmt.build.wrapper];
    };
  };
}
