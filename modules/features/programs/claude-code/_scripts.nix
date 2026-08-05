{pkgs}: let
  inherit (builtins) readDir readFile;
  inherit (pkgs.lib) filterAttrs getExe last mapAttrsToList splitString;
  inherit (pkgs.writers) makeScriptWriter writePython3Bin;
  inherit (pkgs) symlinkJoin;

  writeJqBin = file:
    makeScriptWriter {
      interpreter = "${getExe pkgs.jq} --from-file";
      check = "${getExe pkgs.jq} --null-input --from-file";
    } "/bin/${file}";

  writers = {
    jq = file: writeJqBin file (readFile (./scripts + "/${file}"));
    py = file: writePython3Bin file {} (readFile (./scripts + "/${file}"));
  };

  extension = file: splitString "." file |> last;
in
  symlinkJoin {
    name = "claude-code-scripts";
    paths =
      readDir ./scripts
      |> filterAttrs (_: type: type == "regular")
      |> mapAttrsToList (file: _: writers.${extension file} file);
  }
