{inputs, ...}: {
  flake.modules.nixos.earth = {pkgs, ...}: {
    imports =
      [
        ./_config/configuration.nix
      ]
      ++ (with inputs.self.profiles.nixos; [
        desktop
        gaming
      ])
      ++ (with inputs.self.modules.nixos; [
        base
        _1password
        bluetooth
        coolercontrol
        disko
        docker
        firefox
        fstrim
        nix-helpers
        nvidia
        openrgb
        openssh
        power-profiles
        ryzen
        secure-boot
        spotify
        tailscale
        virt-manager
      ]);

    meta.user = {
      description = "Travis Kinney";
      username = "travis";
    };

    sops = {
      defaultSopsFile = ../../../secrets/secrets.enc.yaml;
      validateSopsFiles = true;

      # An empty string bypasses ssh-to-age key conversion in sops-install-secrets.
      # Temporary workaround to avoid generating intermediate age-keys.txt files
      # until sops-nix natively supports SSH keys. (sops-nix#695, sops-nix#824)
      age.keyFile = "";
      environment = {
        SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/etc/ssh/ssh_host_ed25519_key";
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
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "earth";
}
