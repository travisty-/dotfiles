{
  # https://wiki.nixos.org/wiki/Docker
  flake.modules.nixos.docker = {
    lib,
    config,
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
