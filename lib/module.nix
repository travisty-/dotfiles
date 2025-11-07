{lib, ...}: let
  inherit (lib) fileset;
  inherit (lib.lists) filter map;
  inherit (lib.strings) hasInfix hasSuffix;
  inherit (builtins) toString;
in {
  /**
  Import all modules within the specified path (excluding the root default.nix
  and any modules infixed with a "/_"). This function is intended to be called
  from a "module root" (e.g. /modules/{darwin,home,nixos}/default.nix).
  */
  import = path: let
    root = toString path + "/default.nix";
  in
    path
    |> fileset.toList
    |> map (p: toString p)
    |> filter (f: hasSuffix ".nix" f)
    |> filter (f: ! hasInfix "/_" f)
    |> filter (f: f != root)
    |> map (f: /. + f);

  /**
  Quickly enable a module option.
  */
  enabled.enable = true;

  /**
  Quickly disable a module option.
  */
  disabled.enable = false;
}
