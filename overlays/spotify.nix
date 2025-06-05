# Workaround for Spotify falling back to the default Chromium
# window decorations when running under Wayland in GNOME.
# https://www.reddit.com/r/NixOS/comments/17t8dce
final: prev: {
  spotify = prev.spotify.overrideAttrs (prevAttrs: {
    buildInputs = (prevAttrs.buildInputs or []) ++ [final.makeWrapper];
    postFixup =
      (prevAttrs.postFixup or "")
      + ''
        wrapProgram $out/bin/spotify \
          --set XDG_SESSION_TYPE x11 \
          --unset NIXOS_OZONE_WL \
          --unset WAYLAND_DISPLAY
      '';
  });
}
