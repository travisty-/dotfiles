{
  # https://nixos.wiki/wiki/1Password
  flake.modules.homeManager._1password = {
    config,
    lib,
    pkgs,
    ...
  }: let
    user = config.meta.user;
  in {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        identityAgent = "~/.1password/agent.sock";
      };
    };

    programs.git = {
      enable = true;
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.program = lib.getExe' pkgs._1password-gui "op-ssh-sign";
        user.signingKey = user.signingKey;
      };
    };
  };
}
