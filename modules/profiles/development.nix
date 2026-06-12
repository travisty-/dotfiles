{inputs, ...}: {
  flake.profiles.homeManager.development = {
    imports = with inputs.self.modules.homeManager; [
      claude-code
      deadnix
      devenv
      gh
      git
      helix
      jetbrains
      just
      lazygit
      neovim
      nix-update
      sops
      statix
      vscode
    ];
  };

  flake.profiles.nixos.development = {
    imports = with inputs.self.modules.nixos; [
      docker
      virt-manager
    ];
  };
}
