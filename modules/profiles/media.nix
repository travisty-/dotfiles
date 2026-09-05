{inputs, ...}: {
  flake.profiles.homeManager.media = {
    imports = with inputs.self.modules.homeManager; [
      mpv
      qbittorrent
    ];
  };

  flake.profiles.nixos.media = {
    imports = with inputs.self.modules.nixos; [
      spotify
    ];
  };
}
