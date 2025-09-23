{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.nix-helpers;
in {
  options.settings.programs.nix-helpers = {
    enable = mkEnableOption "Nix helpers";
  };

  # https://nixos.wiki/wiki/Storage_optimization
  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5 --optimise";
      flake = "/etc/nixos";
    };

    environment.systemPackages = with pkgs; [
      nix-inspect
      nix-output-monitor
      nvd
    ];
  };
}
