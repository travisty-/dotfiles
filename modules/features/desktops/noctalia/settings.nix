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
              id = "Launcher";
              useDistroLogo = true;
            }
            {
              id = "Clock";
              formatHorizontal = "h:mm AP ddd, MMM dd";
            }
            {id = "SystemMonitor";}
            {id = "ActiveWindow";}
            {
              id = "MediaMini";
              showVisualizer = true;
            }
          ];
          center = map mkWidget [
            {id = "Workspace";}
          ];
          right = map mkWidget [
            {id = "Tray";}
            {id = "NotificationHistory";}
            {id = "Battery";}
            {id = "Volume";}
            {id = "Brightness";}
            {id = "ControlCenter";}
          ];
        };
      };

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        dimmerOpacity = 0;
      };

      colorSchemes = {
        generationMethod = "content";
        predefinedScheme = "Monochrome";
        useWallpaperColors = true;
      };

      location.useFahrenheit = true;

      wallpaper = {
        directory = "${inputs.wallpapers}";
        overviewEnabled = true;
        viewMode = "recursive";
      };
    };
  };
}
