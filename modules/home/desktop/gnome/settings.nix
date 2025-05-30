{
  config,
  lib,
  options,
  pkgs,
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
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false; # Enables user extensions
          enabled-extensions = [
            pkgs.gnomeExtensions.blur-my-shell.extensionUuid
            pkgs.gnomeExtensions.pop-shell.extensionUuid
          ];
        };
        "org/gnome/shell/extensions/blur-my-shell" = {
          brightness = 0.75;
          noise-amount = 0;
        };
      };

      # Changes the default color theme to dark mode for all GTK4 applications.
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
