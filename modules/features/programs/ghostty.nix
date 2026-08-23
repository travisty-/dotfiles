{
  flake.modules.homeManager.ghostty = {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        background-blur-radius = 20;
        background-opacity = 0.95;
        font-family = "Maple Mono NF";
        # font-feature = "-calt, -liga, -dlig";
        font-feature = [
          "cv01" # Remove gaps
          "cv02" # Alternative A
          "cv07" # Alternative J
          "cv31" # Alternative italic A
          "cv40" # Alternative italic J
          "ss01" # Disable == ligatures
          "ss02" # Disable <= ligatures
          "ss03" # INFO WARN ERROR tags
          "ss04" # Disable __ ligatures
        ];
        font-size = 14;
        keybind = [
          "shift+enter=text:\\n"
        ];
        term = "xterm-256color";
        theme = "iTerm2 Dark Background";
      };
    };
  };
}
