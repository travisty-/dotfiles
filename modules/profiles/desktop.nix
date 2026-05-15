{inputs, ...}: {
  flake.profiles.homeManager.desktop = {
    imports = with inputs.self.modules.homeManager; [
      clipboard
      gtk
      nerd-fonts
      niri
      noctalia
      qt
      vicinae
      xorg
    ];
  };

  flake.profiles.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      fcitx5
      niri
      noctalia
      pipewire
      vicinae
    ];
  };
}
