{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.docker;
in {
  options.${namespace}.programs.docker = {
    enable = mkEnableOption "Docker";
  };

  # https://wiki.nixos.org/wiki/Docker
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      storageDriver = mkIf (config.fileSystems."/".fsType == "btrfs") "btrfs";
    };
  };
}
