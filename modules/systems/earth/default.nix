{inputs, ...}: {
  flake.modules.nixos.earth = {
    imports =
      (with inputs.self.profiles.nixos; [
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
        networking
        nix-helpers
        nvidia
        openrgb
        openssh
        power-profiles
        printing
        ryzen
        secure-boot
        spotify
        tailscale
        virt-manager
        zsh
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
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "earth";
}
