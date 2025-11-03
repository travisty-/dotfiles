{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.meld;
in {
  options.${namespace}.programs.meld = {
    enable = mkEnableOption "Meld";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      meld
    ];
  };
}
