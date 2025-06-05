{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.desktop.gnome;
in {
  options.settings.desktop.gnome = {
    enable = mkEnableOption "GNOME";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;

      # Changes the default color theme to dark mode for all GTK4 applications.
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
