{
  flake.modules.homeManager.zsh = {
    config,
    pkgs,
    ...
  }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
      };

      history = {
        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
        path = "${config.xdg.stateHome}/zsh/history";
        share = true;
      };

      envExtra = ''
        export ZSH_COMPDUMP="${config.xdg.cacheHome}/oh-my-zsh/zcompdump-$ZSH_VERSION"
      '';

      initContent = ''
        setopt BANG_HIST              # Treat the '!' character specially during expansion.
        setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
        setopt HIST_BEEP              # Beep when accessing nonexistent history.
        setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
        setopt HIST_FIND_NO_DUPS      # Don't display a line previously found.
        setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
        setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again.
        setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
        setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
        setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
        setopt HIST_VERIFY            # Don't execute immediately upon history expansion.
        setopt SHARE_HISTORY          # Share history between all sessions.

        bindkey '^H' backward-kill-word
        bindkey ';5C' forward-word
        bindkey ';5D' backward-word
      '';
    };

    home.packages = [
      pkgs.zsh-completions # Used by programs.zsh.enableCompletion
    ];
  };

  flake.modules.nixos.zsh = {pkgs, ...}: {
    programs.zsh.enable = true;
    programs.zsh.enableGlobalCompInit = false; # Use oh-my-zsh's compinit
    environment.shells = [pkgs.zsh];
    environment.pathsToLink = ["/share/zsh"];
  };
}
