{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = _: {
    treefmt.programs = {
      alejandra.enable = true;
      fish_indent.enable = true;
      rumdl-format.enable = true;
    };
  };
}
