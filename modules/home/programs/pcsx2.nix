{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.pcsx2;
in {
  options.settings.programs.pcsx2 = {
    enable = mkEnableOption "PCSX2";
  };

  # https://nixos.wiki/wiki/Playstation2
  # https://wiki.nixos.org/wiki/PlayStation_2
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pcsx2
    ];
  };
}
