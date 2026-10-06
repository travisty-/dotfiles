{inputs, ...}: {
  flake.modules.homeManager.minecraft = {pkgs, ...}: {
    home.packages = [
      inputs.bedrock-on-linux.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
