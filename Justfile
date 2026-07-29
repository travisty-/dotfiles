[private]
default:
    @just --list --unsorted

[group("build")]
update *inputs:
    nix flake update {{inputs}}

[group("build")]
update-package name:
    nix-update --flake --use-update-script {{name}}

[group("build")]
upgrade *args:
    nh os switch {{args}}
    nh home switch {{args}}

[group("build")]
clean:
    nh clean all --keep-since 7d --keep 5 --optimise

[group("lint")]
format:
    nix fmt .

[group("lint")]
check:
    nix flake check

[group("lint")]
lint:
    deadnix --fail .
    statix check .
    rumdl check .

[group("develop")]
evaluate:
    nix repl --expr 'builtins.getFlake (toString ./.)'

[group("develop")]
install:
    nix develop --command true

[group("git"), no-cd]
amend:
    git commit --amend --no-edit

[group("git"), no-cd]
fixup:
    git log --oneline --color=always --max-count=50 \
        | fzf --ansi --accept-nth=1 --prompt='fixup! ' --preview 'git show --color=always {1}' \
        | xargs --no-run-if-empty git commit --fixup

[group("git"), no-cd]
push *args:
    git push --force-with-lease --force-if-includes {{args}}

[group("git"), no-cd]
rebase count *args:
    git rebase -i HEAD~{{count}} --autosquash --autostash --committer-date-is-author-date {{args}}

[group("neovim")]
clone:
    [ -d ~/.config/nvim ] || git clone git@github.com:travisty-/neovim ~/.config/nvim

[group("secrets")]
sops-edit:
    sops secrets/secrets.enc.yaml

[group("secrets")]
sops-rekey:
    sops updatekeys secrets/secrets.enc.yaml

[group("noctalia")]
[script("bash")]
diff-settings:
    nix shell nixpkgs#json-diff --command json-diff \
        <(jq --sort-keys 'del(.location.name)' ~/.config/noctalia/settings.json) \
        <(noctalia-shell ipc call state all | jq --sort-keys '.settings | del(.location.name)')

[group("noctalia")]
dump-settings:
    noctalia-shell ipc call state all | jq .settings

[group("restic")]
[script("bash")]
[working-directory(home_directory())]
restic-excluded depth="4":
    snapshot="$(sudo restic-b2 ls latest)" || exit
    find . -mindepth 1 -maxdepth {{depth}} -type d -printf '%P\n' \
        | grep --fixed-strings --line-regexp --invert-match --file=<(sed "s#^$HOME/##" <<< "$snapshot") \
        | xargs --no-run-if-empty --delimiter='\n' du --summarize --human-readable 2>/dev/null \
        | sort --reverse --human-numeric-sort
