{inputs, ...}: {
  flake.modules.nixos.niri = {pkgs, ...}: let
    niriPkgs = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports = [inputs.niri.nixosModules.niri];

    nix.settings = {
      extra-substituters = ["https://niri-epireyn.cachix.org"];
      extra-trusted-public-keys = ["niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="];
    };

    # Uses substituters instead of extras.
    niri-flake.cache.enable = false;

    programs.niri = {
      enable = true;
      package = niriPkgs.niri-unstable;
    };

    # An application for managing disks and partitions.
    programs.gnome-disks.enable = true;

    # A keyring is required for saving credentials.
    services.gnome.gnome-keyring.enable = true;

    # An application for managing the GNOME keyring.
    programs.seahorse.enable = true;

    # GVFS is required for trash to work in Nautilus.
    services.gvfs.enable = true;

    # Allow Chromium and Electron-based applications to run without Xwayland.
    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
    };
  };
}
