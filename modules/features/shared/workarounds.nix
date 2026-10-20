# Temporary workarounds for upstream Nixpkgs issues. Each entry should link
# its tracking issue and be removed when the issue is closed upstream.
{inputs, ...}: {
  flake.modules.homeManager.base = {
    pkgs,
    lib,
    ...
  }: let
    inherit (inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}) tmux;
  in {
    nixpkgs.overlays = [
      # https://github.com/NixOS/nixpkgs/pull/573028
      (_: prev: {
        tmux = prev.tmux.overrideAttrs {
          version = "3.8";
          src = prev.fetchFromGitHub {
            owner = "tmux";
            repo = "tmux";
            tag = "3.8";
            hash = "sha256-pv2wlr3coo+E0pfpb58giJJQn9PGgMFqtVA6nk+9JdE=";
          };
        };
      })
    ];

    assertions = [
      {
        # https://github.com/tmux/tmux/issues/5056
        assertion = lib.versionOlder tmux.version "3.8";
        message = "tmux is now ${tmux.version} (>= 3.8)";
      }
    ];
  };

  flake.modules.nixos.base = {
    pkgs,
    lib,
    ...
  }: let
    niriGlibc = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable.stdenv.cc.libc;
  in {
    nixpkgs.overlays = [];

    assertions = [
      {
        # https://github.com/sodiboo/niri-flake/issues/1851
        assertion = lib.versionOlder niriGlibc.version pkgs.glibc.version;
        message = "niri-unstable is now on glibc ${niriGlibc.version} (>= ${pkgs.glibc.version})";
      }
    ];
  };
}
