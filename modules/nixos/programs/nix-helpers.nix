{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.nix-helpers;
in {
  options.settings.programs.nix-helpers = {
    enable = mkEnableOption "Nix helpers";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d";
      flake = "/mount/nixos";
    };

    environment.systemPackages = with pkgs; [
      nix-inspect
      nix-output-monitor
      nvd
    ];

    # environment.sessionVariables = {
    #   FLAKE = "/mount/nixos";
    # };
  };
}
