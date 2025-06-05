{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.devenv;
in {
  options.settings.programs.devenv = {
    enable = mkEnableOption "devenv";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      devenv # TODO: Add https://devenv.sh/getting-started/#3-configure-a-github-access-token-optional
    ];
  };
}
