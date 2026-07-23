{inputs, ...}: {
  flake.profiles.homeManager.shell = {
    imports = with inputs.self.modules.homeManager; [
      fish
      nushell
      oh-my-posh
      powershell
      zsh
    ];
  };

  flake.profiles.nixos.shell = {
    imports = with inputs.self.modules.nixos; [
      fish
      zsh
    ];
  };
}
