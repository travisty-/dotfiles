{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.sops;
in {
  options.${namespace}.programs.sops = {
    enable = mkEnableOption "SOPS";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sops
      ssh-to-age
    ];
  };
}
