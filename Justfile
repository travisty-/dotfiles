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

[group("develop")]
evaluate:
    nix repl --expr 'builtins.getFlake (toString ./.)'

[group("develop")]
install:
    nix develop --command true

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
        <(jq --sort-keys . ~/.config/noctalia/settings.json) \
        <(noctalia-shell ipc call state all | jq --sort-keys .settings)

[group("noctalia")]
dump-settings:
    noctalia-shell ipc call state all | jq .settings
