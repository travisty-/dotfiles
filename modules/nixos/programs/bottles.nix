{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.bottles;
in {
  options.${namespace}.programs.bottles = {
    enable = mkEnableOption "Bottles";
  };

  # https://wiki.nixos.org/wiki/Bottles
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
