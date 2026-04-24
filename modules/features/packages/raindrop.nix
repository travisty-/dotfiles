{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.raindrop = pkgs.callPackage "${inputs.self}/packages/raindrop" {};
  };

  flake.modules.homeManager.raindrop = {pkgs, ...}: {
    home.packages = [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.raindrop
    ];
  };
}
