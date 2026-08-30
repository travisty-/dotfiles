{pkgs}: let
  inherit (builtins) readDir readFile;
  inherit (pkgs.lib) filterAttrs mapAttrsToList;
  inherit (pkgs.writers) writePython3Bin;
  inherit (pkgs) symlinkJoin;
in
  symlinkJoin {
    name = "tmux-scripts";
    paths =
      readDir ./scripts
      |> filterAttrs (_: type: type == "regular")
      |> mapAttrsToList (file: _: writePython3Bin file {} (readFile (./scripts + "/${file}")));
  }
