{
  flake.modules.homeManager.git = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.meta) user;
  in {
    programs.git = {
      enable = true;
      ignores = [
        "**/.claude/settings.local.json"
        "**/docs/superpowers/"
      ];
      settings = {
        alias.desc = "\!git log --format=format:'- %s' --reverse origin/\"\${1:-master}\"..HEAD #";
        alias.unstage = "reset HEAD --";
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
        push.useForceIfIncludes = true;
        rebase.autosquash = true;
        rebase.updaterefs = true;
        rerere.autoupdate = true;
        rerere.enabled = true;
        user.email = user.email;
        user.name = user.name;
      };
    };

    programs.difftastic = {
      enable = true;
      git.enable = true;
    };

    home.packages = with pkgs; [
      git-filter-repo
    ];
  };
}
