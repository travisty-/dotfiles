{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    lib = import ./lib {inherit inputs;};
  in {
    homeConfigurations = {
      travis = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [./homes/travis];
        extraSpecialArgs = {
          lib = lib.extend (_: _: home-manager.lib);
          inherit inputs;
        };
      };
    };

    nixosConfigurations = {
      earth = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./systems/earth];
        specialArgs = {
          inherit inputs lib;
        };
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
