{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.gh;
in {
  options.settings.programs.gh = {
    enable = mkEnableOption "GitHub CLI";
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;
    };
  };
}
