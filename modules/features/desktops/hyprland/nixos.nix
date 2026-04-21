{
  # https://wiki.hypr.land/Nix
  flake.modules.nixos.hyprland = {
    config,
    pkgs,
    ...
  }: {
    programs.hyprland.enable = true;

    # The recommended way to start Hyprland on Systemd distros.
    programs.hyprland.withUWSM = true;

    # An application for managing GNOME keyring.
    programs.seahorse.enable = true;

    # An application for managing disks.
    programs.gnome-disks.enable = true;

    # A keyring is required for saving credentials.
    services.gnome.gnome-keyring.enable = true;

    # GVFS is required for trash to work in Nautilus.
    services.gvfs.enable = true;

    # Required for the default Hyprland configuration.
    environment.systemPackages = with pkgs; [
      kitty
      nautilus
      playerctl
    ];

    # Allow Chromium and Electron-based applications to run without Xwayland.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # https://github.com/NixOS/nixpkgs/pull/474174
    environment.sessionVariables.XDG_DATA_DIRS = [
      "${config.programs.hyprland.package}/share"
    ];
  };
}
