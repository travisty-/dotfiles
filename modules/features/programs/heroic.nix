{
  flake.modules.nixos.heroic = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamemode
          pkgs.gamescope
        ];
      })
    ];

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    programs.gamescope.capSysNice = true;
  };
}
