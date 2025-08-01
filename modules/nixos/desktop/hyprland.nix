{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.desktop.hyprland;
in {
  options.settings.desktop.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  # https://wiki.hypr.land/Nix
  config = mkIf cfg.enable {
    programs.hyprland.enable = true;

    # The recommended way to start Hyprland on Systemd distros.
    programs.hyprland.withUWSM = true;

    # An application for managing GNOME keyring.
    programs.seahorse.enable = true;

    # A keyring is required for saving credentials.
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      kitty # Required for the default Hyprland config.
    ];

    # Allow Chromium and Electron-based applications to run without Xwayland.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
