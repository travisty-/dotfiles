{
  flake.modules.nixos.steam = {pkgs, ...}: {
    programs.steam = {
      enable = true;

      # Binds a separate folder over home, so Steam's dotfiles and the saves of native games
      # stay out of the real one. The install is bound back for launchers outside the sandbox.
      # https://github.com/ValveSoftware/steam-for-linux/issues/1890#issuecomment-2367103614
      package = pkgs.steam.override {
        extraBwrapArgs = [
          "--bind $HOME/.local/share/bubblewrap/steam $HOME"
          "--bind $HOME/.local/share/Steam $HOME/.local/share/Steam"
        ];
        extraEnv.NIXOS_XDG_OPEN_USE_PORTAL = "1";
      };

      # Extra packages to be used as compatibility tools for Steam on Linux.
      # Packages will be included in the STEAM_EXTRA_COMPAT_TOOLS_PATHS environment
      # variable. See: https://github.com/ValveSoftware/steam-for-linux/issues/6310
      extraCompatPackages = with pkgs; [proton-ge-bin];

      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    programs.gamescope.capSysNice = true;

    internal.persistence = {
      home.directories = [
        ".local/share/bubblewrap/steam"
        ".local/share/Steam"
      ];
    };
  };
}
