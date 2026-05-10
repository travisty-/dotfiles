{inputs, ...}: {
  flake.profiles.homeManager.desktop = {
    imports = with inputs.self.modules.homeManager; [
      clipboard
      gtk
      hyprland
      nerd-fonts
      niri
      noctalia
      swaync
      vicinae
      waybar
      wlogout
      xorg
    ];
  };

  flake.profiles.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      fcitx5
      hyprland
      niri
      noctalia
      pipewire
      vicinae
    ];
  };
}
