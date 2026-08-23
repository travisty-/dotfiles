{
  flake.modules.homeManager.nerd-fonts = {pkgs, ...}: {
    home.packages =
      (with pkgs.nerd-fonts; [
        geist-mono
        jetbrains-mono
        symbols-only
      ])
      ++ (with pkgs; [
        maple-mono.NF
      ]);
  };
}
