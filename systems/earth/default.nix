{
  inputs,
  lib,
  pkgs,
  ...
}:
with lib.extensions; {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../modules/nixos
    ./configuration.nix
  ];

  nixpkgs.overlays = [
    (import ../../overlays/pop-shell.nix)
    (import ../../overlays/spotify.nix)
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.enc.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    validateSopsFiles = true;
  };

  settings = {
    desktop = {
      gnome = enabled;
    };

    hardware = {
      bluetooth = enabled;
      nvidia = enabled;
      xpadneo = enabled;
    };

    programs = {
      _1password = enabled;
      bottles = enabled;
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
      openssh = enabled;
      pipewire = enabled;
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

  # Enable support for Nix flakes and pipe operators.
  nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];

  # Add trusted users for binary caching.
  nix.settings.trusted-users = ["@wheel"];
}
