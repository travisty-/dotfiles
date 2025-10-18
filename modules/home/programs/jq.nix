{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.jq;
in {
  options.${namespace}.programs.jq = {
    enable = mkEnableOption "jq";
  };

  config = mkIf cfg.enable {
    programs.jq = {
      enable = true;
    };
  };
}
