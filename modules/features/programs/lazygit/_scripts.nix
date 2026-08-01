{pkgs}: let
  inherit (builtins) readDir readFile;
  inherit (pkgs.lib) filterAttrs mapAttrsToList;
  inherit (pkgs) symlinkJoin writeShellScriptBin;
in
  symlinkJoin {
    name = "lazygit-scripts";
    paths =
      readDir ./scripts
      |> filterAttrs (_: type: type == "regular")
      |> mapAttrsToList (file: _: writeShellScriptBin file (readFile (./scripts + "/${file}")));
  }
