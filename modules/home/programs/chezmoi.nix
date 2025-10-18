{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.chezmoi;
in {
  options.${namespace}.programs.chezmoi = {
    enable = mkEnableOption "Chezmoi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chezmoi
    ];
  };
}
