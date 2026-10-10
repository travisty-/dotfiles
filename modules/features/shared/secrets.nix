{inputs, ...}: let
  # An empty key file bypasses ssh-to-age key conversion in sops-install-secrets.
  # SOPS reads the ssh key directly via SOPS_AGE_SSH_PRIVATE_KEY_* vars instead.
  # (sops-nix#695, sops-nix#824)
  shared.sops = {
    age.keyFile = "";
    defaultSopsFile = ../../../secrets/secrets.enc.yaml;
  };
in {
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    inherit (config.meta.user) sshKeyCommand;
  in {
    imports = [inputs.sops-nix.homeManagerModules.sops shared];
    home.sessionVariables.SOPS_AGE_SSH_PRIVATE_KEY_CMD = sshKeyCommand;

    sops.environment = {
      PATH = lib.mkForce "/run/wrappers/bin"; # op read
      SOPS_AGE_SSH_PRIVATE_KEY_CMD = sshKeyCommand;
    };

    systemd.user.services.sops-nix.Service = {
      Restart = "on-failure";
      RestartSec = "1min";
    };
  };

  flake.modules.nixos.base = {
    imports = [inputs.sops-nix.nixosModules.sops shared];

    sops = {
      age.sshKeyPaths = [];
      gnupg.sshKeyPaths = [];
      environment.SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/etc/ssh/ssh_host_ed25519_key";
    };
  };
}
