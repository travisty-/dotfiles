{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.bottles;
in {
  options.settings.programs.bottles = {
    enable = mkEnableOption "Bottles";
  };

  # https://wiki.nixos.org/wiki/Bottles
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
