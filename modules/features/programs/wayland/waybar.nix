{
  flake.modules.homeManager.waybar = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        primary = {
          layer = "bottom";
          position = "top";
          spacing = 10;
          exclusive = true;
          fixed-center = true;
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = ["mpris"];
          modules-right = [
            "tray"
            "clock"
            "wireplumber"
            "custom/notifications"
            "custom/power"
          ];

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              # "1" = "";
              # "2" = "";
              # "3" = "";
              # "4" = "";
              # "5" = "";
              active = "";
              default = "";
              special = "";
            };
            all-outputs = true;
            show-special = true;
            sort-by = "id";
          };

          "hyprland/window" = {
            format = "{initialTitle}";
            # icon = true;
            rewrite = {
              "Mozilla Firefox" = "Firefox";
              "Spotify Premium" = "Spotify";
              "Vicinae Launcher" = "Vicinae";
            };
          };

          mpris = {
            player = "spotify";
            format = "{player_icon} {dynamic}";
            dynamic-order = ["artist" "title"];
            player-icons = {
              default = "";
              spotify = " ";
            };
          };

          tray = {
            show-passive-items = true;
            reverse-direction = true;
            icon-size = 21;
            spacing = 5;
          };

          clock = {
            format = "  {:%I:%M %p}";
            format-alt = "{:%a %b %d %I:%M %p}";
            # format-alt = "󰸗  {:%A, %B %d, %Y}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-scroll-up = "shift_down";
              on-scroll-down = "shift_up";
            };
          };

          wireplumber = {
            format = "{icon} {volume}%";
            format-muted = "  ";
            format-icons = ["  " "  " "  "];
            # on-click = "helvum";
          };

          "custom/notifications" = {
            exec = "swaync-client --subscribe-waybar";
            exec-if = "which swaync-client";
            on-click = "swaync-client --toggle-panel --skip-wait";
            on-click-right = "swaync-client --toggle-dnd --skip-wait";
            format = "<span size='14pt'>{icon}</span>";
            format-icons = {
              none = "󰂜";
              notification = "󱅫";
              dnd-none = "󰪓";
              dnd-notification = "󰂠";
              inhibited-none = "󰪑";
              inhibited-notification = "󰂛";
              dnd-inhibited-none = "󰪑";
              dnd-inhibited-notification = "󰂛";
            };
            return-type = "json";
            tooltip = true;
            escape = true;
          };

          "custom/power" = {
            format = "<span size='14pt'>{icon}</span>";
            format-icons = {
              default = "⏻ ";
            };
            on-click = "wlogout --buttons-per-row 6 --protocol layer-shell &";
            tooltip = false;
          };
        };
      };

      style = ''
        * {
          font-family: "Noto Sans Serif", "Sans Serif";
          font-size: 16px;
          font-weight: 600;
          min-height: 0;
          min-width: 0;
        }

        window#waybar {
          /* background: rgba(0, 0, 0, 0.5); */
          background: transparent;
        }

        #tray,
        #clock,
        #pulseaudio,
        #wireplumber,
        #custom-notifications,
        #custom-power {
          padding: 0px 7px;
        }
      '';
    };
  };
}
