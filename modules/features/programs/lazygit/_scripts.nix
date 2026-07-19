{pkgs}: let
  inherit (builtins) readDir readFile;
  inherit (pkgs.lib) filterAttrs mapAttrsToList pipe;
  inherit (pkgs) symlinkJoin writeShellScriptBin;
in
  symlinkJoin {
    name = "lazygit-scripts";
    paths = pipe (readDir ./scripts) [
      (filterAttrs (_: type: type == "regular"))
      (mapAttrsToList (file: _:
          writeShellScriptBin file (readFile (./scripts + "/${file}"))))
    ];
  }
