{
  flake.modules.homeManager.niri = {
    # Niri uses `xdg-desktop-portal-gnome` so apps like Nautilus read these settings.
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
