{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.flake.profiles = mkOption {
    type = types.attrsOf (types.attrsOf types.deferredModule);
    default = {};
  };
}
