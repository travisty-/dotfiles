# Temporary workarounds for upstream Nixpkgs issues. Each entry should link
# its tracking issue and be removed when the issue is closed upstream.
{inputs, ...}: {
  flake.modules.homeManager.base.nixpkgs.overlays = [];

  flake.modules.nixos.base = {
    pkgs,
    lib,
    ...
  }: let
    inherit (inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}) mozc;
    inherit (inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}) niri-unstable;
  in {
    nixpkgs.overlays = [
      # https://github.com/NixOS/nixpkgs/issues/576522
      (_: prev: {
        mozc = prev.mozc.overrideAttrs (prevAttrs: {
          postPatch =
            prevAttrs.postPatch
            + ''
              substituteInPlace src/gui/dictionary_tool/dictionary_tool.ui \
                --replace-fail "::mozc::gui::DictionaryContentTableWidget" "mozc::gui::DictionaryContentTableWidget"
            '';
        });
      })
    ];

    assertions = [
      {
        # https://github.com/sodiboo/niri-flake/issues/1851
        assertion = lib.versionOlder niri-unstable.stdenv.cc.libc.version pkgs.glibc.version;
        message = "niri-unstable is now on glibc ${niri-unstable.stdenv.cc.libc.version} (>= ${pkgs.glibc.version})";
      }
      {
        # https://github.com/NixOS/nixpkgs/issues/576522
        assertion = mozc.version == "2.30.5544.102" && mozc.patches == [];
        message = "mozc is now ${mozc.version} (patches: ${toString (lib.length mozc.patches)})";
      }
    ];
  };
}
