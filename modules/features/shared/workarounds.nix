# Temporary workarounds for upstream Nixpkgs issues. Each entry should link
# its tracking issue and be removed when the issue is closed upstream.
{
  flake.modules.homeManager.base.nixpkgs.overlays = [];

  flake.modules.nixos.base.nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/issues/514113
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];
}
