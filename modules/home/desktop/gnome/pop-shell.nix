{
  config,
  lib,
  ...
}: let
  cfg = config.settings.desktop.gnome;
in {
  # Workaround for conflicting keybindings between GNOME and Pop Shell.
  # https://github.com/pop-os/shell/blob/master/scripts/configure.sh
  # https://github.com/NixOS/nixpkgs/issues/314969
  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/wm/keybindings" = {
        close = ["<Super>q" "<Alt>F4"];
        minimize = ["<Super>comma"];
        toggle-maximized = ["<Super>m"];
        move-to-monitor-up = [];
        move-to-monitor-down = [];
        move-to-monitor-left = [];
        move-to-monitor-right = [];
        move-to-workspace-up = [];
        move-to-workspace-down = [];
        switch-to-workspace-up = ["<Primary><Super>Up" "<Primary><Super>k"];
        switch-to-workspace-down = ["<Primary><Super>Down" "<Primary><Super>j"];
        switch-to-workspace-left = ["<Primary><Super>Left" "<Primary><Super>h"];
        switch-to-workspace-right = ["<Primary><Super>Right" "<Primary><Super>l"];
        maximize = [];
        unmaximize = [];
      };

      "org/gnome/shell/keybindings" = {
        open-application-menu = [];
        toggle-message-tray = ["<Super>v"];
        toggle-overview = [];
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = [];
        toggle-tiled-right = [];
      };

      "org/gnome/mutter/wayland/keybindings" = {
        restore-shortcuts = [];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = ["<Super>Escape"];
        home = ["<Super>f"];
        www = ["<Super>b"];
        terminal = ["<Super>t"];
        email = ["<Super>e"];
        rotate-video-lock-static = [];
      };

      "org/gnome/shell/extensions/pop-shell" = {
        toggle-tiling = ["<Super>y"];
        toggle-floating = ["<Super>g"];
        tile-enter = ["<Super>Return"];
        tile-accept = ["Return"];
        tile-reject = ["Escape"];
        toggle-stacking-global = ["<Super>s"];
        pop-workspace-up = ["<Shift><Super>Up" "<Shift><Super>k"];
        pop-workspace-down = ["<Shift><Super>Down" "<Shift><Super>j"];
        pop-monitor-left = ["<Shift><Super>Left" "<Shift><Super>h"];
        pop-monitor-right = ["<Shift><Super>Right" "<Shift><Super>l"];
        pop-monitor-up = [];
        pop-monitor-down = [];
        focus-up = ["<Super>Up" "<Super>k"];
        focus-down = ["<Super>Down" "<Super>j"];
        focus-left = ["<Super>Left" "<Super>h"];
        focus-right = ["<Super>Right" "<Super>l"];
      };

      # Workspaces spanning displays work better with Pop Shell.
      "org/gnome/mutter".workspaces-only-on-primary = false;
    };
  };
}
