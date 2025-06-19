{lib, ...}: {
  imports =
    ./.
    |> lib.fileset.fileFilter (file: file.hasExt "nix" && file.name != "default.nix")
    |> lib.fileset.toList;
}
