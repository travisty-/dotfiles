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
      configDir = "${config.xdg.configHome}/claude";
      context = ./_CLAUDE.md;
      rulesDir = ./rules;
      settings = {
        attribution = {
          commit = "";
          pr = "";
        };
        statusLine = {
          command = "${scripts}/bin/statusline-dots.py";
          type = "command";
        };
        enabledPlugins = {
          "code-review@claude-plugins-official" = true;
          "code-simplifier@claude-plugins-official" = true;
          "frontend-design@claude-plugins-official" = true;
          "superpowers@claude-plugins-official" = true;
        };
        env = {
          CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
          CLAUDE_CODE_DISABLE_VIRTUAL_SCROLL = "1";
          CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
          CLAUDE_CODE_NO_FLICKER = "1";
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
        effortLevel = "xhigh";
        keybindingFlavor = "readline";
        outputStyle = "Concise";
        model = "best";
        permissions = {
          defaultMode = "auto";
        };
        voiceEnabled = true;
      };
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };
}
