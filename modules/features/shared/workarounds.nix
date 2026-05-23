# Temporary workarounds for upstream Nixpkgs issues. Each entry should link
# its tracking issue and be removed when the issue is closed upstream.
let
  # https://github.com/NixOS/nixpkgs/issues/523257
  _1password-gui = _: prev: {
    _1password-gui = prev._1password-gui.overrideAttrs (oldAttrs: {
      src = oldAttrs.src.overrideAttrs {
        outputHash = "sha256-JwiMi2iozP6jWSIUtgXla86aSAhuUob7snqtUbeXPpI=";
      };
    });
  };
in {
  flake.modules.homeManager.base.nixpkgs.overlays = [_1password-gui];

  flake.modules.nixos.base.nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/issues/514113
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })

    _1password-gui
  ];
}
