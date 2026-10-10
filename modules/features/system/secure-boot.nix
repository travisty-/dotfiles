{inputs, ...}: {
  flake.modules.nixos.secure-boot = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

    environment.systemPackages = [
      pkgs.sbctl # For debugging and troubleshooting Secure Boot.
    ];

    # Required for TPM to automatically unlock encrypted disks.
    boot.initrd.systemd.enable = true;

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      autoEnrollKeys.enable = true;
      autoGenerateKeys.enable = true;
      pkiBundle = "/var/lib/sbctl";

      # A systemd-pcrlock policy can hold at most 8 PCR alternatives.
      # https://github.com/systemd/systemd/issues/41526
      configurationLimit = 4;

      # | PCR # | Measured objects                                                                      |
      # |-------|---------------------------------------------------------------------------------------|
      # | 0     | Core system firmware executable code                                                  |
      # | 1     | Core system firmware data/host platform configuration; typically serial/model numbers |
      # | 2     | Extended or pluggable executable code; includes option ROMs on pluggable hardware     |
      # | 3     | Extended or pluggable firmware data; includes information about pluggable hardware    |
      # | 4     | Boot loader and additional drivers; binaries and extensions loaded by the boot loader |
      # | 7     | Secure boot state                                                                     |

      # https://nix-community.github.io/lanzaboote/how-to-guides/enable-measured-boot.html
      # https://uapi-group.org/specifications/specs/linux_tpm_pcr_registry

      measuredBoot = {
        enable = true;
        pcrs = [0 4 7];

        # My firmware never logs the EV_EFI_ACTION "Calling EFI Application from Boot Option"
        # event into PCR 4, so the upstream 350-action-efi-application component will never
        # match, causing systemd-pcrlock to drop PCR 4 from the policy.
        upstreamStaticMeasurements = lib.mkForce [
          "400-secureboot-separator.pcrlock.d/300-0x00000000.pcrlock"
          "500-separator.pcrlock.d/300-0x00000000.pcrlock"
        ];
      };
    };
  };
}
