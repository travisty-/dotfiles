{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./configuration.nix
    ../../modules/nixos
  ];

  nixpkgs.overlays = [
    (import ../../overlays/spotify.nix)
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.enc.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    validateSopsFiles = true;
  };

  settings = {
    desktop = {
      gnome.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
      xpadneo.enable = true;
    };

    programs = {
      _1password.enable = true;
      bottles.enable = true;
      docker.enable = true;
      firefox.enable = true;
      heroic.enable = true;
      lutris.enable = true;
      nix-helpers.enable = true;
      spotify.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };

    services = {
      openssh.enable = true;
      pipewire.enable = true;
      tailscale.enable = true;
    };
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
}
