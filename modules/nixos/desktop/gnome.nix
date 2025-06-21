{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.desktop.gnome;

  # Workaround for missing Pop Shell keybindings and schemas.
  extensions =
    pkgs.gnomeExtensions
    // {
      pop-shell = pkgs.gnomeExtensions.pop-shell.overrideAttrs (
        prevAttrs: {
          postInstall =
            (prevAttrs.postInstall or "")
            + ''
              # Workaround for: https://github.com/NixOS/nixpkgs/issues/92265
              mkdir --parents "$out/share/gsettings-schemas/$name/glib-2.0"
              ln --symbolic "$out/share/gnome-shell/extensions/pop-shell@system76.com/schemas" "$out/share/gsettings-schemas/$name/glib-2.0/schemas"

              # Workaround for: https://github.com/NixOS/nixpkgs/issues/314969
              mkdir --parents "$out/share/gnome-control-center"
              ln --symbolic "$src/keybindings" "$out/share/gnome-control-center/keybindings"
            '';
        }
      );
    };
in {
  options.settings.desktop.gnome = {
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
    services.displayManager.autoLogin.user = "travis";

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    # Workaround for: https://github.com/NixOS/nixpkgs/issues/92265
    services.desktopManager.gnome.sessionPath = [extensions.pop-shell];

    # Add udev rules for systray icons: https://wiki.nixos.org/wiki/GNOME#Systray_Icons
    services.udev.packages = with pkgs; [gnome-settings-daemon];

    # Workaround for GNOME profile picture: https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36232/10
    systemd.tmpfiles.rules = let
      username = "travis";
    in [
      "f+ /var/lib/AccountsService/users/${username}  0577 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${username}\\n"
      "L+ /var/lib/AccountsService/icons/${username}  - - - - /home/${username}/.face"
    ];

    environment.systemPackages = with extensions; [
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
