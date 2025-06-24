{inputs, ...}:
inputs.nixpkgs.lib.extend (final: _: {
  extensions = (
    import ./module.nix {lib = final;}
  );
})
