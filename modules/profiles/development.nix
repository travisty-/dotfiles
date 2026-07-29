{inputs, ...}: {
  flake.profiles.homeManager.development = {
    imports = with inputs.self.modules.homeManager; [
      claude-code
      deadnix
      devenv
      editorconfig
      gh
      git
      helix
      jetbrains
      just
      lazygit
      neovim
      nix-update
      rumdl
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
