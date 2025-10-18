{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.git;
  user = config.meta.user;
in {
  options.${namespace}.programs.git = {
    enable = mkEnableOption "Git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = user.name;
      userEmail = user.email;

      aliases = {
        desc = "\!git log --format=format:'- %s' --reverse origin/\"\${1:-master}\"..HEAD #";
        unstage = "reset HEAD --";
      };

      difftastic = {
        enable = true;
      };

      extraConfig = {
        am.threeway = true;
        apply.ignorewhitespace = "change";
        core.editor = "vi";
        fetch.prune = true;
        help.autocorrect = -1;
        log.abbrevcommit = true;
        log.decorate = "short";
        pull.ff = "only";
        pull.rebase = true;
        push.autosetupremote = true;
        push.default = "current";
        rebase.autosquash = true;
        rebase.updaterefs = true;
        rerere.autoupdate = true;
        rerere.enabled = true;
      };
    };

    home.packages = with pkgs; [
      git-filter-repo
    ];
  };
}
