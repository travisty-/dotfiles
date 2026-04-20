{
  # https://wiki.nixos.org/wiki/Filesystems
  flake.modules.nixos.fstrim = {
    services.fstrim.enable = true;
  };
}
