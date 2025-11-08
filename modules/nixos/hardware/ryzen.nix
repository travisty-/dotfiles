{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.hardware.ryzen;
in {
  options.${namespace}.hardware.ryzen = {
    enable = mkEnableOption "AMD Ryzen CPU";
  };

  # https://gist.github.com/dlqqq/876d74d030f80dc899fc58a244b72df0
  config = mkIf cfg.enable {
    boot.kernelParams = [
      "amd_pstate=active"
      "intel_idle.max_cstate=0"
      "processor.max_cstate=1"
    ];
  };
}
