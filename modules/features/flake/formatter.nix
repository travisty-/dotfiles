{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = _: {
    treefmt.programs = {
      alejandra.enable = true;
    };
  };
}
