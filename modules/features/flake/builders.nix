{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkOption types;
in {
  options.flake.lib = mkOption {
    type = types.attrsOf types.unspecified;
    default = {};
  };

  config.flake.lib = {
    mkHome = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [config.flake.modules.homeManager.${name}];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

    mkNixos = system: name: {
      ${name} = lib.nixosSystem {
        inherit system;
        modules = [
          config.flake.modules.nixos.${name}
          {nixpkgs.hostPlatform = mkDefault system;}
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
