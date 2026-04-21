{inputs, ...}: {
  flake.profiles.homeManager.gaming = {
    imports = with inputs.self.modules.homeManager; [
      discord
      minecraft
      osu
      pcsx2
    ];
  };

  flake.profiles.nixos.gaming = {
    imports = with inputs.self.modules.nixos; [
      bottles
      heroic
      lutris
      steam
      xpadneo
    ];
  };
}
