{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.nerd-fonts;
in {
  options.${namespace}.programs.nerd-fonts = {
    enable = mkEnableOption "Nerd Fonts";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.nerd-fonts; [
      geist-mono
      jetbrains-mono
      symbols-only
    ];
  };
}
