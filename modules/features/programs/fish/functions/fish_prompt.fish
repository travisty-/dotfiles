function _prompt_git
    GIT_OPTIONAL_LOCKS=0 command git $argv 2>/dev/null
end

function _prompt_git_ref
    if _prompt_git rev-parse --git-dir >/dev/null
        _prompt_git symbolic-ref --short HEAD
        or _prompt_git describe --tags --exact-match HEAD
        or _prompt_git rev-parse --short HEAD
    end
end

function _prompt_git_dirty
    test -n "$(_prompt_git status --porcelain --ignore-submodules=dirty)"
end

function fish_prompt --description="robbyrussell"
    set -l last_status $status
    set -l green (set_color -o green)
    set -l red (set_color -o red)
    set -l cyan (set_color -o cyan)
    set -l blue (set_color -o blue)
    set -l yellow (set_color -o yellow)
    set -l purple (set_color -o 7c3aed)
    set -l reset (set_color reset)

    set -l arrow
    if test $last_status -eq 0
        set arrow "$green➜"
    else
        set arrow "$red➜"
    end

    set -l cwd "$cyan$(path basename (prompt_pwd))"

    set -l parts "$arrow  $cwd"

    set -l ref (_prompt_git_ref)
    if test -n "$ref"
        set -a parts "$blue git:($red$ref$blue)"
        if _prompt_git_dirty
            set -a parts "$yellow ✗"
        end
    end

    if set -q DEVENV_ROOT
        set -a parts "$purple ●"
    end

    echo -n -s $parts $reset ' '
end
