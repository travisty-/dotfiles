{
  flake.modules.homeManager.zoxide = {lib, ...}: {
    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };

    # Add frecent directories to cd's tab completion (similar to z).
    # Must run after zoxide's init, as it clears cd's completions.
    programs.fish.interactiveShellInit = lib.mkAfter ''
      complete --command cd --keep-order --no-files \
        --condition '__fish_is_first_arg; and string match --quiet --regex -- "^[^/~.]" (commandline -ct)' \
        --arguments '(zoxide query --list --exclude $PWD)'
    '';

    programs.zsh.initContent = lib.mkAfter ''
      function _cd_zoxide() {
        __zoxide_z_complete

        if (( CURRENT == 2 )) && [[ -n $PREFIX && $PREFIX != [/~.]* ]]; then
          local -a expl results=(''${(f)"$(zoxide query --list --exclude $PWD)"})
          _description directories expl 'frecent directory'
          if compadd "$expl[@]" -o nosort -a results; then
            compstate[insert]=menu
          fi
        fi

        (( compstate[nmatches] > 0 ))
      }

      compdef _cd_zoxide cd
    '';
  };
}
