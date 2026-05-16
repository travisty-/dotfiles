{
  # https://nixos.wiki/wiki/Steam
  flake.modules.nixos.steam = {pkgs, ...}: {
    programs.steam = {
      enable = true;

      # Extra packages to be used as compatibility tools for Steam on Linux.
      # Packages will be included in the STEAM_EXTRA_COMPAT_TOOLS_PATHS environment
      # variable. See: https://github.com/ValveSoftware/steam-for-linux/issues/6310.
      extraCompatPackages = with pkgs; [proton-ge-bin];

      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    programs.gamescope.capSysNice = true;
  };
}
