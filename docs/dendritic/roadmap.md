# Dendritic Roadmap

Things to do after the initial migration.

## Profiles

Desktop and gaming profiles are implemented. Profiles are namespaced under `flake.profiles.<class>.<name>` (custom option defined in `features/flake/profiles.nix`), separate from features at `flake.modules.<class>.<name>`. Add more profiles as needed when onboarding additional systems.

Candidates for future profiles: cli, development, media, terminal, productivity, communication.

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

## Known issues

### Hardcoded `/etc/nixos/` paths

mpv and jetbrains modules hardcode `/etc/nixos/...` in `mkOutOfStoreSymlink` calls. Could add a `meta.repoPath` option set once in the user module, but it's still a hardcoded value either way.
