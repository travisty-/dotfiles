{
  flake.modules.homeManager.niri = {
    lib,
    pkgs,
    ...
  }: {
    # Niri uses `xdg-desktop-portal-gnome` so apps like Nautilus read these settings.
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    # `lib.mkForce` overrides hyprland/hyprcursor.nix (temporary).
    home.pointerCursor = lib.mkForce {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
    };

    # https://github.com/niri-wm/niri/issues/1914
    programs.zsh.loginExtra = ''
      if [[ -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
        exec niri-session -l
      fi
    '';
  };
}
