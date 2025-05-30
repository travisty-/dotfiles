{
  config,
  lib,
  options,
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
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "travis";

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    # Workaround for: https://github.com/NixOS/nixpkgs/issues/92265
    services.xserver.desktopManager.gnome.sessionPath = [extensions.pop-shell];

    environment.systemPackages = with extensions; [
      blur-my-shell
      pop-shell
    ];

    # Allow Chromium and Electron-based applications to run without Xwayland.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
