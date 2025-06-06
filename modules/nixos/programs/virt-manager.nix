{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.virt-manager;
in {
  options.settings.programs.virt-manager = {
    enable = mkEnableOption "virt-manager";
  };

  # https://wiki.nixos.org/wiki/Virt-manager
  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;

    virtualisation.libvirtd.qemu.vhostUserPackages = [pkgs.virtiofsd];

    users.users.travis.extraGroups = ["libvirtd"];
  };
}
