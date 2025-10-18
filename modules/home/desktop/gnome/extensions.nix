{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib.hm.gvariant) mkUint32;
  cfg = config.${namespace}.desktop.gnome;
in {
  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs; [
          gnomeExtensions.appindicator.extensionUuid
          gnomeExtensions.blur-my-shell.extensionUuid
          gnomeExtensions.clipboard-history.extensionUuid
          gnomeExtensions.lilypad.extensionUuid
          gnomeExtensions.pop-shell.extensionUuid
          gnomeExtensions.unblank.extensionUuid
        ];
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        brightness = 0.75;
        noise-amount = 0;
      };

      "org/gnome/shell/extensions/pop-shell" = {
        active-hint = true;
        active-hint-border-radius = mkUint32 5;
        gap-inner = mkUint32 2;
        gap-outer = mkUint32 2;
        mouse-cursor-follows-active-window = true;
        show-skip-taskbar = true;
        show-title = true;
        stacking-with-mouse = true;
        tile-by-default = true;
      };

      "org/gnome/shell/extensions/lilypad" = {
        reorder = true;
        lilypad-order = [
          "spotify_client"
          "steam"
          "StatusNotifierItem"
        ];
        rightbox-order = [
          "lilypad"
          "pop_shell"
          "Clipboard_History_Indicator"
        ];
      };

      "org/gnome/shell/extensions/unblank" = {
        power = true;
        time = 900;
      };
    };
  };
}
