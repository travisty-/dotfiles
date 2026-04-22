{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    # https://nixos.wiki/wiki/Btrfs#Scrubbing
    services.btrfs.autoScrub.enable =
      lib.any (fs: fs.fsType == "btrfs")
      (lib.attrValues config.fileSystems);
  };
}
