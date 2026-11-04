{inputs, ...}: {
  flake.profiles.homeManager.development = {
    imports = with inputs.self.modules.homeManager; [
      claude-code
      claude-desktop
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
      claude-desktop
      docker
      virt-manager
    ];
  };
}
