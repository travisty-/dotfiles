{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      term = "xterm-256color";
    };
  };
}
