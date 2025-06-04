{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.docker;
in {
  options.settings.programs.docker = {
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
