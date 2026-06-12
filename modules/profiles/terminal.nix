{inputs, ...}: {
  flake.profiles.homeManager.terminal = {
    imports = with inputs.self.modules.homeManager; [
      alacritty
      fish
      ghostty
      oh-my-posh
      powershell
      zsh
    ];
  };

  flake.profiles.nixos.terminal = {
    imports = with inputs.self.modules.nixos; [
      fish
      zsh
    ];
  };
}
