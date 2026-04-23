[private]
default:
    @just --list --unsorted

[group("build")]
update *inputs:
    nix flake update {{inputs}}

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
