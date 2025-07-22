{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;

    defaultFonts = {
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK JP"
      ];

      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
      ];

      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
      ];
    };
  };
}
