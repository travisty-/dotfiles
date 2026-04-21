{
  flake.modules.homeManager.qbittorrent = {pkgs, ...}: {
    nixpkgs.overlays = [
      # Workaround for qBittorrent not exposing a setting to use the default
      # light mode theme when `QT_STYLE_OVERRIDE` is set to prefer dark mode.
      (final: prev: {
        qbittorrent = prev.qbittorrent.overrideAttrs (prevAttrs: {
          buildInputs = (prevAttrs.buildInputs or []) ++ [final.makeWrapper];
          postFixup =
            (prevAttrs.postFixup or "")
            + ''
              wrapProgram $out/bin/qbittorrent \
                --unset QT_STYLE_OVERRIDE
            '';
        });
      })
    ];

    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}
