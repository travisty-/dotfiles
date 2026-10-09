{
  flake.modules.homeManager.firefox = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) attrValues flip genAttrs;
  in {
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
        HttpsOnlyMode = "force_enabled";
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        DNSOverHTTPS = {
          Enabled = true;
          Fallback = false;
          ProviderURL = "https://security.cloudflare-dns.com/dns-query";
          Locked = true;
        };
        EnableTrackingProtection = {
          Cryptomining = true;
          Fingerprinting = true;
          Value = true;
          Locked = true;
        };
        ExtensionSettings =
          {
            adaptive-tab-bar-colour = "ATBC@EasonWong";
            dark-reader = "addon@darkreader.org";
            kagi-search = "search@kagi.com";
            load-reddit-images-directly = "{4c421bb7-c1de-4dc6-80c7-ce8625e34d24}";
            multi-account-containers = "@testpilot-containers";
            onepassword = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
            raindrop = "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack";
            ublock-origin = "uBlock0@raymondhill.net";
            violentmonkey = "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}";
          }
          |> attrValues
          |> flip genAttrs (_: {installation_mode = "normal_installed";});
        FirefoxHome = {
          Highlights = false;
          SponsoredStories = false;
          SponsoredTopSites = false;
          Stories = false;
          TopSites = false;
          Weather = false;
          Locked = true;
        };
      };

      profiles.default = {
        search = {
          force = true;
          default = "kagi";

          order = [
            "kagi"
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
            kagi = {
              name = "Kagi";
              urls = [{template = "https://kagi.com/search?q={searchTerms}";}];
              icon = "https://kagi.com/favicon.ico";
              definedAliases = ["@kagi" "@k"];
            };

            nix-packages = {
              name = "Nix Packages";
              urls = [{template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nix-packages" "@np"];
            };

            nix-options = {
              name = "Nix Options";
              urls = [{template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";}];
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
              urls = [{template = "https://github.com/search?type=code&q=repo:nix-community/home-manager%20{searchTerms}";}];
              icon = "https://github.com/favicon.ico";
              definedAliases = ["@home-manager" "@hm"];
            };

            github-nixpkgs = {
              name = "Nixpkgs";
              urls = [{template = "https://github.com/search?type=code&q=repo:NixOS/nixpkgs%20{searchTerms}";}];
              icon = "https://github.com/favicon.ico";
              definedAliases = ["@nixpkgs" "@ng"];
            };

            nyaa = {
              name = "Nyaa";
              urls = [{template = "https://nyaa.si?f=0&c=1_2&q={searchTerms}%201080p%20-HEVC";}];
              icon = "https://nyaa.si/static/favicon.png";
              definedAliases = ["@nyaa" "@ny"];
            };

            nyaa-subsplease = {
              name = "Subsplease";
              urls = [{template = "https://nyaa.si/user/subsplease?f=0&c=1_2&q={searchTerms}%201080p%20-HEVC";}];
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
          "browser.ai.control.default" = "blocked";
          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.privateWindowSeparation.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.tabs.loadBookmarksInBackground" = true;
          "browser.urlbar.scotchBonnet.enableOverride" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.quicksuggest.all" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.suggest.topsites" = false;
          "browser.urlbar.suggest.trending" = false;
          "extensions.autoDisableScopes" = 0;
          "extensions.pocket.enabled" = false;
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";
          "full-screen-api.warning.timeout" = 0;
          "network.dns.disablePrefetch" = true;
          "network.http.speculative-parallel-limit" = 0;
          "network.prefetch-next" = false;
          "sidebar.revamp" = false;
          "signon.firefoxRelay.feature" = "disabled";
          "signon.generation.enabled" = false;
          "widget.gtk.native-context-menus" = false;
        };

        userChrome = ''
          @namespace url(http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul);

          /* https://github.com/atbc-org/Adaptive-Tab-Bar-Colour#customising-colour-transitions */
          body, findbar, #navigator-toolbox, #TabsToolbar, #nav-bar, #PersonalToolbar, #sidebar-box, .tab-background, .urlbar-background {
            transition:
              background-color 0.5s cubic-bezier(0, 0, 0, 1) !important,
              border-color 0.5s cubic-bezier(0, 0, 0, 1) !important,
              outline 0.5s cubic-bezier(0, 0, 0, 1) !important;
          }

          /* https://github.com/atbc-org/Adaptive-Tab-Bar-Colour#adaptive-theme-in-context-menus */
          :is(menupopup, panel):where(:not([type="arrow"])) {
            --panel-background-color: unset !important;
            --panel-border-color: unset !important;
          }
        '';
      };
    };
  };

  flake.modules.nixos.firefox = {
    programs.firefox.enable = true;
  };
}
