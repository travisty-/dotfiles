{
  # https://wiki.nixos.org/wiki/Heroic_Games_Launcher
  flake.modules.nixos.heroic = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamemode
          pkgs.gamescope
        ];
      })
    ];
  };
}
