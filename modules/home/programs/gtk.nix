{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.settings.programs.gtk;
in {
  options.settings.programs.gtk = {
    enable = mkEnableOption "GTK";
    bookmarks = mkOption {
      description = "Bookmarks in the sidebar of a GTK file manager.";
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      gtk3.bookmarks = cfg.bookmarks;
    };
  };
}
