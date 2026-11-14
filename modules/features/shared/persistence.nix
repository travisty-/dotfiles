{lib, ...}: let
  inherit (lib) mkOption types;

  # Declares a list of entries, each a path matching `pattern` or an attribute set with `directory` or `file`.
  mkEntryOption = pattern: description:
    mkOption {
      inherit description;
      type = types.listOf (types.either (types.strMatching pattern) types.attrs);
      default = [];
      apply = lib.unique;
    };

  # Persistence options are shared across classes for simplicity. Home Manager doesn't set
  # the root options, and home options declared in NixOS are owned by the host's main user.
  options.internal.persistence = {
    root = {
      directories = mkEntryOption "/.*" "Directories outside home persisted across boots.";
      files = mkEntryOption "/.*" "Files outside home persisted across boots.";
    };
    home = {
      directories = mkEntryOption "[^/].*" "Directories in home persisted across boots.";
      files = mkEntryOption "[^/].*" "Files in home persisted across boots.";
    };
  };
in {
  flake.modules.homeManager.base = {
    inherit options;

    config.internal.persistence = {
      home.directories = [
        ".cache/nix"
        ".local/state/home-manager"
        ".local/state/nix"
      ];
    };
  };

  flake.modules.nixos.base = {config, ...}: {
    inherit options;

    config.internal.persistence = {
      root.directories = [
        {
          directory = config.meta.flake;
          user = config.meta.user.username;
          group = "users";
        }
      ];
    };
  };
}
