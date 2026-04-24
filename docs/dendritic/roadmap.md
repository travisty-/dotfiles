# Dendritic Roadmap

Things to do after the initial migration.

## Profiles

Desktop and gaming profiles are implemented as manual import lists under `modules/profiles/`, namespaced at `flake.profiles.<class>.<name>` (custom option defined in `features/flake/profiles.nix`), separate from features at `flake.modules.<class>.<name>`. Add more profiles as needed when onboarding additional systems.

Candidates for future profiles: cli, development, media, terminal, productivity, communication.

## Custom Packages

Custom packages live under `packages/<name>/` (outside `modules/` so import-tree doesn't try to evaluate them as flake-parts modules). Each is wired via a per-file module at `modules/features/packages/<name>.nix` that both exposes the package as a flake output and provides a cross-cutting feature module:

```nix
{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.raindrop = pkgs.callPackage "${inputs.self}/packages/raindrop" {};
  };

  flake.modules.homeManager.raindrop = {pkgs, ...}: {
    home.packages = [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.raindrop
    ];
  };
}
```

Consumers reference the package directly via the flake output. Explicit, verbose, no machinery beyond the feature module itself — appropriate for a small number of packages.

### Extension paths

Two options reduce consumer boilerplate without adding flake inputs.

**SpecialArg (`custom.raindrop`).** Inject packages as a specialArg via builders:

```nix
# modules/features/flake/builders.nix
extraSpecialArgs = {
  inherit inputs;
  custom = inputs.self.packages.${system};
};
# same addition to specialArgs in mkNixos
```

Consumers destructure `{custom, ...}:` and reference `custom.raindrop`. The name signals "this flake's custom packages," distinct from `pkgs` (upstream nixpkgs). No overlay eval cost.

**Namespaced overlay (`pkgs.local.raindrop`).** Define the overlay and register it through builders:

```nix
flake.overlays.default = _: prev: {
  local = inputs.self.packages.${prev.stdenv.hostPlatform.system};
};
```

Apply via `nixpkgs.overlays` inside both builders. Requires `mkHome` to build pkgs via `import inputs.nixpkgs { overlays = [...]; }` rather than `legacyPackages`. Gains `self.overlays.default` as an externally-consumable flake output; matches the reference dendritic convention.

### When to migrate

Direct reference fits one or two packages. Jump to specialArg when the `inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.*` boilerplate starts to grate (~3+ consumers). Adopt the overlay only if external flakes need `self.overlays.default` or you want ecosystem alignment with the overlay-based dendritic convention.

## Statix: repeated_keys (W:20)

`repeated_keys` is disabled in `statix.toml` to preserve the per-line
assignment style the repo was written in (e.g., `programs.steam = {...}; programs.gamemode.enable = ...;`
rather than `programs = { steam = {...}; gamemode.enable = ...; };`).

16 sites across 11 files would trigger the rule if re-enabled. 12 exist
because flattening would either bury load-bearing per-line comments
(hyprland, gnome, secure-boot, vicinae, git) or merge genuinely separate
subsystems sharing a prefix (`internal.*` in `travis@earth`). The other 4
(`shared/config.nix`, `shared/boot.nix`, `programs/steam.nix`,
`programs/1password.nix`) could flatten cleanly, but fixing only those
creates a hybrid — worse than either pure approach.

Decision: Keep disabled.
