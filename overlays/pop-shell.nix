# Workaround for missing Pop Shell keybindings and schemas.
_: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      pop-shell = prev.gnomeExtensions.pop-shell.overrideAttrs (prevAttrs: {
        postInstall =
          (prevAttrs.postInstall or "")
          + ''
            # Workaround for: https://github.com/NixOS/nixpkgs/issues/92265
            mkdir --parents "$out/share/gsettings-schemas/$name/glib-2.0"
            ln --symbolic "$out/share/gnome-shell/extensions/pop-shell@system76.com/schemas" "$out/share/gsettings-schemas/$name/glib-2.0/schemas"

            # Workaround for: https://github.com/NixOS/nixpkgs/issues/314969
            mkdir --parents "$out/share/gnome-control-center"
            ln --symbolic "$src/keybindings" "$out/share/gnome-control-center/keybindings"
          '';
      });
    };
}
