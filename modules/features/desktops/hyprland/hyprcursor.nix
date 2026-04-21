{
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprcursor
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    config = {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
        package = pkgs.rose-pine-hyprcursor;
        name = "rose-pine-hyprcursor";
      };
    };
  };
}
