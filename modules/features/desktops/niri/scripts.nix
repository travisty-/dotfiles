{
  flake.modules.homeManager.niri = {
    lib,
    pkgs,
    ...
  }: let
    inherit (builtins) readDir readFile;
    inherit (lib) filterAttrs mapAttrsToList pipe;
    inherit (pkgs) symlinkJoin writeShellScriptBin;
  in {
    _module.args.scripts = symlinkJoin {
      name = "niri-scripts";
      paths = pipe (readDir ./scripts) [
        (filterAttrs (_: type: type == "regular"))
        (mapAttrsToList (file: _:
          writeShellScriptBin file
          (readFile (./scripts + "/${file}"))))
      ];
    };
  };
}
