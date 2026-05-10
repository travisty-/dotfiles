# https://wiki.nixos.org/wiki/Noctalia_Shell
{inputs, ...}: {
  flake.modules.homeManager.noctalia = {pkgs, ...}: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = false;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    home.packages = [pkgs.libnotify];
  };

  flake.modules.nixos.noctalia = {
    nix.settings = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    };

    # https://docs.noctalia.dev/v4/getting-started/nixos
    hardware.bluetooth.enable = true;
    networking.networkmanager.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
  };
}
