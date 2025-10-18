{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.hm.gvariant) mkUint32;
  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = {
    enable = mkEnableOption "GNOME";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/datetime" = {
          automatic-timezone = true;
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          font-antialiasing = "rgba";
        };

        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
        };

        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 0;
        };

        "org/gnome/mutter" = {
          edge-tiling = false;
          experimental-features = ["variable-refresh-rate"];
        };

        "org/gnome/nautilus/list-view" = {
          use-tree-view = true;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          power-button-action = "interactive";
          sleep-inactive-ac-type = "nothing";
        };

        "org/gnome/shell" = {
          favorite-apps = [
            "1password.desktop"
            "firefox.desktop"
            "spotify.desktop"
            "steam.desktop"
            "discord.desktop"
            "code.desktop"
            "obsidian.desktop"
          ];
          last-selected-power-profile = "performance"; # TODO
        };

        "org/gnome/desktop/interface".clock-format = "12h";
        "org/gtk/settings/file-chooser".clock-format = "12h";
      };
    };
  };
}
