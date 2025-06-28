{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs._1password;
  user = config.meta.user;
in {
  options.settings.programs._1password = {
    enable = mkEnableOption "1Password";
  };

  # https://nixos.wiki/wiki/1Password
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
            IdentityAgent ~/.1password/agent.sock
      '';
    };

    programs.git = {
      enable = true;
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.program = lib.getExe' pkgs._1password-gui "op-ssh-sign";
        user.signingKey = user.signingKey;
      };
    };
  };
}
