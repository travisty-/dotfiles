{
  # https://wiki.nixos.org/wiki/Docker
  flake.modules.nixos.docker = {
    config,
    lib,
    ...
  }: {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      storageDriver = lib.mkIf (config.fileSystems."/".fsType == "btrfs") "btrfs";
    };
  };
}
