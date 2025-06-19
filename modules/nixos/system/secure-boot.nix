{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.system.secure-boot;
in {
  options.settings.system.secure-boot = {
    enable = mkEnableOption "Secure Boot";
  };

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # https://wiki.nixos.org/wiki/Secure_Boot
  # https://nixos.wiki/wiki/Secure_Boot
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sbctl # For debugging and troubleshooting Secure Boot.
    ];

    # Required for TPM to automatically unlock encrypted disks.
    boot.initrd.systemd.enable = true;

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
