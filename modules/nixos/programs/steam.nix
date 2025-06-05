{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.steam;
in {
  options.settings.programs.steam = {
    enable = mkEnableOption "Steam";
  };

  # https://nixos.wiki/wiki/Steam
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;

      # Extra packages to be used as compatibility tools for Steam on Linux.
      # Packages will be included in the STEAM_EXTRA_COMPAT_TOOLS_PATHS environment
      # variable. See: https://github.com/ValveSoftware/steam-for-linux/issues/6310.
      extraCompatPackages = with pkgs; [proton-ge-bin];

      gamescopeSession.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;
  };
}
