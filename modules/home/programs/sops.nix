{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.sops;
in {
  options.settings.programs.sops = {
    enable = mkEnableOption "SOPS";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sops
      ssh-to-age
    ];
  };
}
