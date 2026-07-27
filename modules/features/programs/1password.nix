{
  flake.modules.homeManager._1password = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.meta) user;
    inherit (lib) getExe' mkIf;
  in {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        IdentityAgent = "~/.1password/agent.sock";
      };
    };

    programs.git = mkIf (config.programs.git.enable && user.signingKey != null) {
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = toString (pkgs.writeTextFile {
          name = "git-allowed-signers";
          text = ''${user.email} namespaces="git" ${user.signingKey}'';
        });
        gpg.ssh.program = getExe' pkgs._1password-gui "op-ssh-sign";
        user.signingKey = user.signingKey;
      };
    };
  };

  flake.modules.nixos._1password = {config, ...}: let
    inherit (config.meta.user) username;
  in {
    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    # Certain features, including CLI integration and system authentication support,
    # require enabling polkit integration on some desktop environments (e.g. Plasma).
    programs._1password-gui.polkitPolicyOwners = [username];
  };
}
