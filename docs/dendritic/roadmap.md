# Dendritic Roadmap

Things to do after the initial migration.

## Profiles

Desktop and gaming profiles are implemented. Profiles are namespaced under `flake.profiles.<class>.<name>` (custom option defined in `features/flake/profiles.nix`), separate from features at `flake.modules.<class>.<name>`. Add more profiles as needed when onboarding additional systems.

Candidates for future profiles: cli, development, media, terminal, productivity, communication.

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

### Tag-based profiles (future)

Instead of manually listing modules in each profile, modules could self-declare their tags:

```nix
# modules/programs/btop.nix
{
  flake.modules.homeManager.btop = {
    programs.btop.enable = true;
  };

  tags = ["cli"];
}
```

A resolver would then collect all modules with a given tag into a profile automatically. Adding a new module with a tag would include it everywhere that tag is used.

Trade-off: you can't see what's in a profile by reading just the profile file.

Open questions:

- How to define the `tags` option and the resolver infrastructure
- Whether tags should be per-class (`tags.homeManager = ["cli"]`) or flat (`tags = ["cli"]`)
