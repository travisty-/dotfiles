{
  lib,
  namespace,
  ...
}: {
  imports = lib.${namespace}.import ./.;
}
