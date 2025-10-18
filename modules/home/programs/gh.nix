{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.gh;
in {
  options.${namespace}.programs.gh = {
    enable = mkEnableOption "GitHub CLI";
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;
    };
  };
}
