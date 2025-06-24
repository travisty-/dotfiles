{lib, ...}: let
  fs = lib.fileset;
in {
  /**
  Lists all modules under the specified path (excluding any default.nix).
  This function is intended to be used to import file-based modules from
  a "module root" (e.g. /modules/{darwin,home,nixos}/default.nix).
  */
  listModules = path:
    path
    |> fs.fileFilter (f: f.hasExt "nix" && f.name != "default.nix")
    |> fs.toList;

  /**
  Quickly enable a module option.
  */
  enabled = {
    enable = true;
  };

  /**
  Quickly disable a module option.
  */
  disabled = {
    enable = false;
  };
}
