{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
      statix.settings.config = "${inputs.self}/statix.toml";
    };

    devShells.default = pkgs.mkShell {
      inherit (config.pre-commit) shellHook;
      packages = config.pre-commit.settings.enabledPackages;
    };
  };
}
