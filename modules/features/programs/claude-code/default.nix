{
  flake.modules.homeManager.claude-code = {
    config,
    pkgs,
    ...
  }: let
    scripts = import ./_scripts.nix {inherit pkgs;};
  in {
    programs.claude-code = {
      enable = true;
      package = pkgs.claude-code.overrideAttrs {
        postInstall = "wrapProgram $out/bin/claude --prefix PATH : ${pkgs.nodejs}/bin";
      };
      configDir = "${config.xdg.configHome}/claude";
      context = ./_CLAUDE.md;
      rulesDir = ./rules;
      skills = ./skills;
      settings = {
        attribution = {
          commit = "";
          pr = "";
          sessionUrl = false;
        };
        statusLine = {
          command = "${scripts}/bin/statusline-dots.py";
          type = "command";
        };
        extraKnownMarketplaces = {
          ponytail.source = {
            source = "github";
            repo = "DietrichGebert/ponytail";
          };
        };
        enabledPlugins = {
          "code-review@claude-plugins-official" = true;
          "code-simplifier@claude-plugins-official" = true;
          "frontend-design@claude-plugins-official" = true;
          "superpowers@claude-plugins-official" = true;
          "ponytail@ponytail" = true;
        };
        env = {
          CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
          CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
        };
        hooks = {
          MessageDisplay = [
            {
              hooks = [
                {
                  command = "${scripts}/bin/timestamp-display.jq";
                  type = "command";
                }
              ];
            }
          ];
          UserPromptSubmit = [
            {
              hooks = [
                {
                  command = "${scripts}/bin/timestamp-context.jq";
                  type = "command";
                }
              ];
            }
          ];
        };
        autoMode = {
          hard_deny = ["$defaults"];
          soft_deny = ["$defaults"];
        };
        effortLevel = "high";
        keybindingFlavor = "readline";
        outputStyle = "Concise";
        model = "best";
        permissions = {
          defaultMode = "auto";
        };
        tui = "fullscreen";
        voiceEnabled = true;
      };
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };
}
