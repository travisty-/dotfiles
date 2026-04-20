{
  flake.modules.homeManager.gtk = {
    lib,
    config,
    ...
  }: let
    inherit (lib) mkOption types;
    cfg = config.internal.programs.gtk;
  in {
    options.internal.programs.gtk = {
      bookmarks = mkOption {
        description = "Bookmarks in the sidebar of a GTK file manager.";
        type = types.listOf types.str;
        default = [];
      };
    };

    config = {
      gtk = {
        enable = true;
        gtk3.bookmarks = cfg.bookmarks;
      };
    };
  };
}
