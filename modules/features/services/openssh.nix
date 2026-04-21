{
  # https://nixos.wiki/wiki/SSH
  flake.modules.nixos.openssh = {lib, ...}: {
    services.openssh.enable = true;

    # Prevent the SSH server from auto-starting.
    systemd.services.sshd.wantedBy = lib.mkForce [];
  };
}
