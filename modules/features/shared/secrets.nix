{inputs, ...}: let
  # An empty string bypasses ssh-to-age key conversion in sops-install-secrets.
  # Temporary workaround to avoid generating intermediate age-keys.txt files
  # until sops-nix natively supports SSH keys. (sops-nix#695, sops-nix#824)
  mkSopsConfig = keyFile: {
    age.keyFile = "";
    defaultSopsFile = ../../../secrets/secrets.enc.yaml;
    environment.SOPS_AGE_SSH_PRIVATE_KEY_FILE = keyFile;
    validateSopsFiles = true;
  };
in {
  flake.modules.homeManager.base = {config, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    sops = mkSopsConfig "${config.home.homeDirectory}/.ssh/id_ed25519";
  };

  flake.modules.nixos.base = {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = mkSopsConfig "/etc/ssh/ssh_host_ed25519_key";
  };
}
