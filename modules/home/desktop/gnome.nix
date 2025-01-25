{
  config,
  pkgs,
  ...
}: {
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
  };
}
