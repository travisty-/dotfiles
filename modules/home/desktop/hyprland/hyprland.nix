{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.settings.desktop.hyprland;
in {
  options.settings.desktop.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  options.settings.desktop.hyprland.settings = {
    monitors = mkOption {
      description = "The target monitor settings.";
      type = types.listOf types.str;
    };
  };

  # https://wiki.hypr.land/Nix
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;

    # Use the Hyprland and XDPH packages from the NixOS module.
    wayland.windowManager.hyprland.package = null;
    wayland.windowManager.hyprland.portalPackage = null;

    # Disable the systemd integration as it conflicts with uwsm.
    wayland.windowManager.hyprland.systemd.enable = false;

    # https://wiki.hypr.land/Configuring
    wayland.windowManager.hyprland.settings = {
      monitor = cfg.settings.monitors;

      "$terminal" = "ghostty";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";

      exec-once = [
        "[workspace special:magic silent] uwsm app -- $terminal"
        "systemctl --user enable --now hyprpolkitagent.service"
        "systemctl --user enable --now swaync.service"
      ];

      # ecosystem = {
      #   enforce_permissions = 1;
      # };

      # Any permission changes require a Hyprland restart
      # and are not applied on-the-fly for security reasons.
      # permission = [
      #   "/usr/(bin|local/bin)/grim, screencopy, allow"
      #   "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow"
      #   "/usr/(bin|local/bin)/hyprpm, plugin, allow"
      # ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false; # Set to true enable resizing windows by clicking and dragging on borders and gaps.
        allow_tearing = false; # See https://wiki.hypr.land/Configuring/Tearing before turning this on.
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1.0"
          "quick, 0.15, 0, 0.1, 1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # Uncomment to use "Smart gaps" / "No gaps when only".
      # See https://wiki.hypr.land/Configuring/Workspace-Rules
      # workspace = [
      #   "w[tv1], gapsout:0, gapsin:0"
      #   "f[1], gapsout:0, gapsin:0"
      # ];

      # windowrule = [
      #   "bordersize 0, floating:0, onworkspace:w[tv1]"
      #   "rounding 0, floating:0, onworkspace:w[tv1]"
      #   "bordersize 0, floating:0, onworkspace:f[1]"
      #   "rounding 0, floating:0, onworkspace:f[1]"
      # ];

      dwindle = {
        pseudotile = true; # Master switch for pseudotiling.
        preserve_split = true; # You probably want this.
        force_split = 2; # Always split to the right.
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers.
        disable_hyprland_logo = true; # Disables the random Hyprland logo and anime girl background. :(
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0; # -1.0 to 1.0. 0 means no modification.

        accel_profile = "flat"; # Disable cursor acceleration.

        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      # Example device-specific configuration.
      # device = {
      #   name = "epic-mouse-v1";
      #   sensitivity = -0.5;
      # };

      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier.

      bind = [
        "$mainMod, Q, exec, uwsm app -- $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exec, uwsm stop"
        "$mainMod, E, exec, uwsm app -- $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, uwsm app -- $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle

        # Screenshot a region, window, or monitor.
        ", PRINT, exec, uwsm app -- hyprshot --mode region --freeze --clipboard-only"
        "$mainMod, PRINT, exec, uwsm app -- hyprshot --mode window --freeze --clipboard-only"
        "$mainMod SHIFT, PRINT, exec, uwsm app -- hyprshot --mode output --freeze --clipboard-only"

        # Move focus with mainMod + arrow keys.
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9].
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9].
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Special workspace (scratchpad).
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces.
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Move and resize windows with LMB and RMB.
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Laptop multimedia keys.
      bindel = [
        ",XF86AudioRaiseVolume, exec, uwsm app -- wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, uwsm app -- wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, uwsm app -- wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, uwsm app -- wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, uwsm app -- brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, uwsm app -- brightnessctl -e4 -n2 set 5%-"
      ];

      # Media player controls (requires playerctl).
      bindl = [
        ", XF86AudioNext, exec, uwsm app -- playerctl next"
        ", XF86AudioPause, exec, uwsm app -- playerctl play-pause"
        ", XF86AudioPlay, exec, uwsm app -- playerctl play-pause"
        ", XF86AudioPrev, exec, uwsm app -- playerctl previous"
      ];

      windowrule = [
        # Example: "float,class:^(kitty)$,title:^(kitty)$"

        # Ignore maximize requests from apps.
        "suppressevent maximize, class:.*"

        # Fix some window dragging issues with XWayland.
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };

    # https://github.com/nix-community/home-manager/issues/6061
    wayland.windowManager.hyprland.extraConfig = ''
      # Enter submap to resize the active window.
      bind = $mainMod, Return, submap, resize
      submap = resize
          bind = , left, resizeactive, -50 0
          bind = , right, resizeactive, 50 0
          bind = , up, resizeactive, 0 50
          bind = , down, resizeactive, 0 -50

          bind = , H, resizeactive, -50 0
          bind = , L, resizeactive, 50 0
          bind = , K, resizeactive, 0 50
          bind = , J, resizeactive, 0 -50

          bind = , Return, submap, reset
          bind = , Escape, submap, reset
      submap = reset
    '';

    # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#in-tty
    programs.zsh.loginExtra = ''
      if uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';

    # Installing GTK desktop portal as XDPH doesn't implement a file picker.
    # https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#NixOS-UWSM
    # xdg.configFile."uwsm/env".source = "${home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    # https://wiki.hypr.land/Configuring/Environment-variables
    xdg.configFile."uwsm/env".text = ''
      export NIXOS_OZONE_WL=1
      export XCURSOR_SIZE=32
    '';

    # https://wiki.hypr.land/Configuring/Environment-variables
    xdg.configFile."uwsm/env-hyprland".text = ''
      export HYPRCURSOR_SIZE=32
    '';

    # https://wiki.hypr.land/Useful-Utilities/Must-have/#qt-wayland-support
    qt.enable = true;

    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#fixing-problems-with-themes
    gtk = {
      enable = true;

      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      font = {
        name = "Sans";
        size = 11;
      };
    };
  };
}
