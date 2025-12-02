{
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
with lib.${namespace}; {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../modules/nixos
    ./configuration.nix
  ];

  meta.user = {
    description = "Travis Kinney";
    username = "travis";
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.enc.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    validateSopsFiles = true;
  };

  ${namespace} = {
    desktop = {
      hyprland = enabled;
    };

    hardware = {
      bluetooth = enabled;
      nvidia = enabled;
      ryzen = enabled;
      xpadneo = enabled;
    };

    programs = {
      _1password = enabled;
      bottles = enabled;
      coolercontrol = enabled;
      docker = enabled;
      firefox = enabled;
      heroic = enabled;
      lutris = enabled;
      nix-helpers = enabled;
      spotify = enabled;
      steam = enabled;
      virt-manager = enabled;
    };

    services = {
      fstrim = enabled;
      openrgb = enabled;
      openssh = enabled;
      pipewire = enabled;
      power-profiles = enabled;
      tailscale = enabled;
    };

    system.secure-boot = enabled;
  };

  # https://nixos.wiki/wiki/Btrfs#Scrubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  # Install Zsh.
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
  users.defaultUserShell = pkgs.zsh;

  # Enables completion for system packages (e.g. systemd).
  environment.pathsToLink = ["/share/zsh"];

  # Set the default text editor for the system.
  environment.sessionVariables.EDITOR = "vi";
}
