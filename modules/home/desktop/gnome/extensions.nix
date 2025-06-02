{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.hm.gvariant) mkUint32;
  cfg = config.settings.desktop.gnome;
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
        rightbox-order = [
          "StatusNotifierItem"
          "lilypad"
          "pop_shell"
          "Clipboard_History_Indicator"
        ];
      };
    };
  };
}
