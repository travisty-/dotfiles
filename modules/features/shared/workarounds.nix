# Temporary workarounds for upstream Nixpkgs issues. Each entry should link
# its tracking issue and be removed when the issue is closed upstream.
{
  flake.modules.homeManager.base.nixpkgs.overlays = [];

  flake.modules.nixos.base.nixpkgs.overlays = [];
}
