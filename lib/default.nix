{
  inputs,
  namespace,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in
  lib.extend (final: _: {
    ${namespace} = lib.mergeAttrsList [
      (import ./module.nix {lib = final;})
    ];
  })
