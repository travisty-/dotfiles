{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.matrix;
in {
  options.${namespace}.programs.matrix = {
    enable = mkEnableOption "Matrix";
  };

  # https://nixos.wiki/wiki/Matrix
  config = mkIf cfg.enable {
    programs.element-desktop = {
      enable = true;
    };
  };
}
