{inputs, ...}: {
  flake.profiles.homeManager.desktop = {
    imports = with inputs.self.modules.homeManager; [
      gtk
      hyprland
      nerd-fonts
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
      pipewire
      vicinae
    ];
  };
}
