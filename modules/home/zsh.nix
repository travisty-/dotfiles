{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.zsh;
in {
  options.settings.programs.zsh = {
    enable = mkEnableOption "Zsh";
  };

  config = mkIf cfg.enable {
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
        share = true;
      };

      initExtra = ''
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
        setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
        setopt SHARE_HISTORY          # Share history between all sessions.

        bindkey '^H' backward-kill-word
        bindkey ';5C' forward-word
        bindkey ';5D' backward-word
      '';

      profileExtra = ''
        # Add user's private bin to PATH, if it exists.
        if [ -d "$HOME/bin" ]; then
            PATH="$HOME/bin:$PATH"
        fi

        # Add user's private bin to PATH, if it exists.
        if [ -d "$HOME/.local/bin" ]; then
            PATH="$HOME/.local/bin:$PATH"
        fi
      '';
    };
  };
}
