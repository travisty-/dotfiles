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
    mkHome = name: system: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [config.flake.modules.homeManager.${name}];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

    mkNixos = name: system: {
      ${name} = lib.nixosSystem {
        inherit system;
        modules = [
          config.flake.modules.nixos.${name}
          {
            networking.hostName = mkDefault name;
            nixpkgs.hostPlatform = mkDefault system;
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
