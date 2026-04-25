{
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprlock
  flake.modules.homeManager.hyprland = {
    config = {
      programs.hyprlock = {
        enable = true;

        settings = {
          general = {
            hide_cursor = true;
            ignore_empty_input = true;
          };

          animations = {
            enabled = true;
            fade_in = {
              duration = 300;
              bezier = "easeOutQuint";
            };
            fade_out = {
              duration = 300;
              bezier = "easeOutQuint";
            };
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              monitor = "";
              size = "200, 50";
              position = "0, -80";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
              outline_thickness = 5;
              shadow_passes = 2;
            }
          ];
        };
      };
    };
  };

  flake.modules.nixos.hyprland = {
    security.pam.services.hyprlock = {};
  };
}
