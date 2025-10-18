{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.ghostty;
in {
  options.${namespace}.programs.ghostty = {
    enable = mkEnableOption "Ghostty";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        background-blur-radius = 20;
        background-opacity = 0.95;
        font-family = "GeistMono NF";
        font-feature = "-calt"; # -liga, -dlig
        font-size = 14;
        keybind = [
          "shift+enter=text:\\n"
        ];
        term = "xterm-256color";
        theme = "Adwaita Dark";
      };
    };
  };
}
