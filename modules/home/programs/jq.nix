{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.jq;
in {
  options.settings.programs.jq = {
    enable = mkEnableOption "jq";
  };

  config = mkIf cfg.enable {
    programs.jq = {
      enable = true;
    };
  };
}
