{
  flake.modules.homeManager.niri = {
    config,
    lib,
    ...
  }: let
    inherit (lib) mkOption types;
    cfg = config.internal.desktops.niri;
  in {
    options.internal.desktops.niri = {
      outputs = mkOption {
        description = "Configures outputs (monitors).";
        type = types.attrsOf types.attrs;
        default = {};
      };

      workspaces = mkOption {
        description = "Configures named workspaces.";
        type = types.attrsOf types.attrs;
        default = {};
      };

      profilePicture = mkOption {
        description = "Path to the user's profile picture.";
        type = types.path;
      };
    };

    config = {
      home.file.".face".source = cfg.profilePicture;
    };
  };
}
