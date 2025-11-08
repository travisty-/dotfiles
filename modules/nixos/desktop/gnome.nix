{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.meta.user) username;
  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = {
    enable = mkEnableOption "GNOME";
  };

  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = username;

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    # Workaround for: https://github.com/NixOS/nixpkgs/issues/92265
    services.desktopManager.gnome.sessionPath = [pkgs.gnomeExtensions.pop-shell];

    # Add udev rules for systray icons: https://wiki.nixos.org/wiki/GNOME#Systray_Icons
    services.udev.packages = with pkgs; [gnome-settings-daemon];

    # Workaround for GNOME profile picture: https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36232/10
    systemd.tmpfiles.rules = [
      "f+ /var/lib/AccountsService/users/${username}  0577 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${username}\\n"
      "L+ /var/lib/AccountsService/icons/${username}  - - - - /home/${username}/.face"
    ];

    environment.systemPackages = with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      clipboard-history
      lilypad
      pop-shell
      unblank
    ];

    environment.gnome.excludePackages = with pkgs; [gnome-tour];

    services.xserver.excludePackages = with pkgs; [xterm];

    # Allow Chromium and Electron-based applications to run without Xwayland.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
