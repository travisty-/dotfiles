{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.firefox;
in {
  options.${namespace}.programs.firefox = {
    enable = mkEnableOption "Firefox";
  };

  # https://nixos.wiki/wiki/Firefox
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };

      profiles.default = {
        search = {
          force = true;
          default = "ddg";

          order = [
            "ddg"
            "nix-packages"
            "nix-options"
            "nix-wiki"
            "mynixos"
            "noogle"
            "github-home-manager"
            "github-nixpkgs"
            "nyaa"
            "nyaa-subsplease"
          ];

          engines = {
            nix-packages = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nix-packages" "@np"];
            };

            nix-options = {
              name = "Nix Options";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nix-options" "@no"];
            };

            nix-wiki = {
              name = "Nix Wiki";
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              icon = "https://wiki.nixos.org/favicon.ico";
              definedAliases = ["@nix-wiki" "@nw"];
            };

            mynixos = {
              name = "MyNixOS";
              urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
              icon = "https://mynixos.com/favicon.ico";
              definedAliases = ["@mynixos" "@my"];
            };

            noogle = {
              name = "Noogle";
              urls = [{template = "https://noogle.dev/q?term={searchTerms}";}];
              icon = "https://noogle.dev/favicon.ico";
              definedAliases = ["@noogle" "@ns"];
            };

            github-home-manager = {
              name = "Home Manager";
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "type";
                      value = "code";
                    }
                    {
                      name = "q";
                      value = "repo:nix-community/home-manager {searchTerms}";
                    }
                  ];
                }
              ];
              icon = "https://github.com/favicon.ico";
              definedAliases = ["@home-manager" "@hm"];
            };

            github-nixpkgs = {
              name = "Nixpkgs";
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "type";
                      value = "code";
                    }
                    {
                      name = "q";
                      value = "repo:NixOS/nixpkgs {searchTerms}";
                    }
                  ];
                }
              ];
              icon = "https://github.com/favicon.ico";
              definedAliases = ["@nixpkgs" "@ng"];
            };

            nyaa = {
              name = "Nyaa";
              urls = [
                {
                  template = "https://nyaa.si";
                  params = [
                    {
                      name = "f";
                      value = "0";
                    }
                    {
                      name = "c";
                      value = "1_2";
                    }
                    {
                      name = "q";
                      value = "{searchTerms} 1080p -HEVC";
                    }
                  ];
                }
              ];
              icon = "https://nyaa.si/static/favicon.png";
              definedAliases = ["@nyaa" "@ny"];
            };

            nyaa-subsplease = {
              name = "Subsplease";
              urls = [
                {
                  template = "https://nyaa.si/user/subsplease";
                  params = [
                    {
                      name = "f";
                      value = "0";
                    }
                    {
                      name = "c";
                      value = "1_2";
                    }
                    {
                      name = "q";
                      value = "{searchTerms} 1080p -HEVC";
                    }
                  ];
                }
              ];
              icon = "https://nyaa.si/static/favicon.png";
              definedAliases = ["@subsplease" "@sp"];
            };

            # https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox/profiles/search.nix
            amazondotcom-us.metaData.hidden = true;
            bing.metaData.hidden = true;
            ebay.metaData.hidden = true;
            google.metaData.hidden = true;
            perplexity.metaData.hidden = true;
            wikipedia.metaData.hidden = true;
          };
        };

        settings = {
          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.privateWindowSeparation.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.tabs.groups.smart.enabled" = false;
          "browser.tabs.groups.smart.userEnabled" = false;
          "browser.tabs.loadBookmarksInBackground" = true;
          "browser.urlbar.scotchBonnet.enableOverride" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.topsites" = false;
          "extensions.autoDisableScopes" = 0;
          "extensions.ml.enabled" = false;
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
