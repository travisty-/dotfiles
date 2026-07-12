# Temporary workarounds for upstream Nixpkgs issues. Each entry should link
# its tracking issue and be removed when the issue is closed upstream.
{
  flake.modules.homeManager.base = {
    pkgs,
    lib,
    ...
  }: {
    nixpkgs.overlays = [];

    assertions = [
      {
        # https://github.com/tmux/tmux/issues/5056
        assertion = lib.versionOlder pkgs.tmux.version "3.7c";
        message = "tmux is now ${pkgs.tmux.version} (>= 3.7c)";
      }
    ];
  };

  flake.modules.nixos.base.nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/issues/540025
    (_: prev: {
      pythonPackagesExtensions =
        prev.pythonPackagesExtensions
        ++ [
          (_: pyprev: {
            patool = pyprev.patool.overridePythonAttrs (_: {doCheck = false;});
          })
        ];
    })
  ];
}
