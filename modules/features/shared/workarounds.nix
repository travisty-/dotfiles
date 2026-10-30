# Temporary workarounds for upstream Nixpkgs issues. Each entry should link
# its tracking issue and be removed when the issue is closed upstream.
{inputs, ...}: {
  flake.modules.homeManager.base.nixpkgs.overlays = [];

  flake.modules.nixos.base = {
    pkgs,
    lib,
    ...
  }: let
    inherit (inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}) niri-unstable;
  in {
    nixpkgs.overlays = [];

    assertions = [
      {
        # https://github.com/sodiboo/niri-flake/issues/1851
        assertion = lib.versionOlder niri-unstable.stdenv.cc.libc.version pkgs.glibc.version;
        message = "niri-unstable is now on glibc ${niri-unstable.stdenv.cc.libc.version} (>= ${pkgs.glibc.version})";
      }
    ];
  };
}
