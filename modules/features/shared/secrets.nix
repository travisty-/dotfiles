{inputs, ...}: {
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    inherit (config.meta.user) sshKeyCommand;
  in {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    home.sessionVariables.SOPS_AGE_SSH_PRIVATE_KEY_CMD = sshKeyCommand;

    sops = {
      age.sshKeyCmd = sshKeyCommand;
      defaultSopsFile = ../../../secrets/secrets.enc.yaml;
      environment.PATH = lib.mkForce "/run/wrappers/bin"; # op read
    };

    # Upstream defines the unit only while sops.secrets is non-empty.
    systemd.user.services.sops-nix = lib.mkIf (config.sops.secrets != {}) {
      Service = {
        Restart = "on-failure";
        RestartSec = "1min";
      };
    };
  };

  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      # System activation runs in initrd before the host keys are linked, so the key is read from its persistent path.
      age.sshKeyFile = lib.optionalString (config.preservation.enable or false) "/persist" + "/etc/ssh/ssh_host_ed25519_key";
      defaultSopsFile = ../../../secrets/secrets.enc.yaml;
      gnupg.sshKeyPaths = [];
    };
  };
}
