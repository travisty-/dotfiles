{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.openssh;
in {
  options.${namespace}.services.openssh = {
    enable = mkEnableOption "OpenSSH";
  };

  # https://nixos.wiki/wiki/SSH
  config = mkIf cfg.enable {
    services.openssh.enable = true;

    # Prevent the SSH server from auto-starting.
    systemd.services.sshd.wantedBy = lib.mkForce [];
  };
}
