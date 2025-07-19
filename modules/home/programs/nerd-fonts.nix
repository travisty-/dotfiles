{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.nerd-fonts;
in {
  options.settings.programs.nerd-fonts = {
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
