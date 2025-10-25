{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.file;
in {
  options.${namespace}.programs.file = {
    enable = mkEnableOption "File";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      file
    ];
  };
}
