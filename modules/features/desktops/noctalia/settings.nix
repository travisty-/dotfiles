{inputs, ...}: {
  flake.modules.homeManager.noctalia = {
    config,
    lib,
    ...
  }: let
    inherit (lib) importJSON recursiveUpdate;

    # Pre-fills the default settings so what's on disk matches what's in memory,
    # allowing us to declare only overrides while still keeping our diffs clean.
    defaults = importJSON "${inputs.noctalia}/Assets/settings-default.json";
    widgetDefaults = importJSON "${inputs.noctalia}/Assets/settings-widgets-default.json";
    mkWidget = widget: recursiveUpdate (widgetDefaults.bar.${widget.id} or {}) widget;
  in {
    programs.noctalia-shell.settings = recursiveUpdate defaults {
      settingsVersion = 59;

      bar = {
        barType = "floating";
        widgets = {
          left = map mkWidget [
            {
              id = "Workspace";
              labelMode = "none";
            }
            {
              id = "SystemMonitor";
              compactMode = false;
              showMemoryAsPercent = true;
            }
            {
              id = "ActiveWindow";
              showText = false;
            }
          ];
          center = map mkWidget [
            {
              id = "MediaMini";
              maxWidth = 400;
              scrollingMode = "always";
              showArtistFirst = false;
              showVisualizer = true;
            }
          ];
          right = map mkWidget [
            {
              id = "Tray";
              blacklist = ["Keyboard*"];
              colorizeIcons = true;
              drawerEnabled = false;
            }
            {id = "Volume";}
            {id = "Battery";}
            {
              id = "NotificationHistory";
              hideWhenZeroUnread = true;
            }
            {
              id = "Clock";
              formatHorizontal = "ddd MMM d h:mm AP";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        dimmerOpacity = 0;
      };

      dock = {
        groupApps = true;
        groupClickAction = "list";
      };

      colorSchemes = {
        generationMethod = "content";
        predefinedScheme = "Monochrome";
        useWallpaperColors = true;
      };

      location.useFahrenheit = true;

      nightLight = {
        enabled = true;
        nightTemp = "5000";
      };

      wallpaper = {
        directory = "${inputs.wallpapers}";
        overviewEnabled = true;
        viewMode = "recursive";
      };
    };
  };
}
