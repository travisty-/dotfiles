{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.firefox;
in {
  options.settings.programs.firefox = {
    enable = mkEnableOption "Firefox";
  };

  # https://nixos.wiki/wiki/Firefox
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.default = {
        settings = {
          "browser.privateWindowSeparation.enabled" = false;
          "browser.tabs.loadBookmarksInBackground" = true;
          "extensions.autoDisableScopes" = 0;
          "extensions.pocket.enabled" = false;
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";
          "full-screen-api.warning.timeout" = 0;
        };

        userChrome = ''
          @namespace url(http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul);
        '';
      };
    };
  };
}
