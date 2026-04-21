{
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent
  flake.modules.homeManager.hyprland = {
    config = {
      services.hyprpolkitagent = {
        enable = true;
      };
    };
  };
}
