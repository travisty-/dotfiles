{inputs, ...}: {
  flake.modules.homeManager.noctalia = {
    config,
    pkgs,
    ...
  }: {
    # https://docs.noctalia.dev/noctalia/configuration
    programs.noctalia = {
      settings = {
        shell = {
          avatar_path = "${config.home.homeDirectory}/.face";
          clipboard_enabled = false;
          clipboard_keep_from_closed_apps = false;
          launch_apps_as_systemd_services = true;
          setup_wizard_enabled = false;
        };

        bar.main = {
          start = ["workspaces" "cpu" "temp" "ram" "active_window"];
          center = ["media" "audio_visualizer"];
          end = ["tray" "volume" "battery" "notifications" "clock" "control-center"];
          margin_edge = 4;
          margin_ends = 4;
        };

        widget = {
          workspaces.show_labels = false;
          ram.stat = "ram_pct";
          active_window.display = "icon_only";
          media = {
            hide_when_no_media = true;
            max_length = 400;
            title_scroll = "always";
          };
          tray = {
            hidden = ["fcitx"];
            hide_passive = false;
          };
          notifications.hide_when_no_unread = true;
          clock.format = "{:%a %b %-d %-I:%M %p}";
          control-center.custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        };

        theme.source = "wallpaper";

        backdrop.enabled = true;

        dock = {
          enabled = true;
          auto_hide = true;
          reserve_space = false;
          margin_edge = 8;
        };

        location.auto_locate = true;

        weather.unit = "imperial";

        nightlight = {
          enabled = true;
          temperature_night = 5000;
        };

        wallpaper.directory = "${inputs.wallpapers}";
      };

      customPalettes.Monochrome = ./palettes/monochrome.json;
    };
  };
}
