{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.claude-code;

  statuslineScripts =
    pkgs.runCommandLocal "claude-code-statusline" {
      nativeBuildInputs = [pkgs.python3];
    } ''
      mkdir -p $out/bin
      for file in ${../../../files/config/claude/scripts}/*.py; do
        install -m 755 "$file" "$out/bin/$(basename "$file")"
      done
      patchShebangs $out/bin
    '';
in {
  options.${namespace}.programs.claude-code = {
    enable = mkEnableOption "Claude Code";
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      settings = {
        attribution = {
          commit = "";
          pr = "";
        };
        statusLine = {
          command = "${statuslineScripts}/bin/statusline-dots.py";
          type = "command";
        };
        enabledPlugins = {
          "code-review@claude-plugins-official" = true;
          "code-simplifier@claude-plugins-official" = true;
          "frontend-design@claude-plugins-official" = true;
          "superpowers@claude-plugins-official" = true;
        };
        env = {
          CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING = "1";
          CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
          CLAUDE_CODE_DISABLE_VIRTUAL_SCROLL = "1";
          CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
          CLAUDE_CODE_NO_FLICKER = "1";
        };
        model = "opus[1m]";
        effortLevel = "xhigh";
        skipAutoPermissionPrompt = true;
        voiceEnabled = true;
      };
    };
  };
}
