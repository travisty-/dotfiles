{
  # https://wiki.nixos.org/wiki/Virt-manager
  flake.modules.nixos.virt-manager = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.meta.user) username;
  in {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;

    virtualisation.libvirtd.qemu.vhostUserPackages = [pkgs.virtiofsd];

    users.users.${username}.extraGroups = ["libvirtd"];
  };
}
