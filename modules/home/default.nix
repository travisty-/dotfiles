{
  lib,
  namespace,
  ...
}: {
  imports = lib.${namespace}.listModules ./.;
}
