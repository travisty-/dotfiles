{inputs, ...}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home
  ];

  # TODO: Remove generated key file in $XDG_RUNTIME_DIR/secrets.d
  # once sops-nix natively supports encryption/decryption via SSH.
  sops = {
    defaultSopsFile = ../../secrets/secrets.enc.yaml;
    age.sshKeyPaths = ["/home/travis/.ssh/id_ed25519"];
    validateSopsFiles = true;
  };

  settings = {
    desktop = {
      gnome.enable = true;
      gnome.resources = {
        profilePicture = ../../files/images/crying-bear.png;
        wallpaper = ../../files/wallpapers/medusa.png;
      };
    };

    programs = {
      _1password.enable = true;
      alacritty.enable = true;
      deadnix.enable = true;
      devenv.enable = true;
      direnv.enable = true;
      discord.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fd.enable = true;
      fzf.enable = true;
      gh.enable = true;
      ghostty.enable = true;
      git.enable = true;
      jq.enable = true;
      just.enable = true;
      mpv.enable = true;
      neovim.enable = true;
      obsidian.enable = true;
      powershell.enable = true;
      qbittorrent.enable = true;
      remmina.enable = true;
      ripgrep.enable = true;
      sops.enable = true;
      statix.enable = true;
      subtitleedit.enable = true;
      vscode.enable = true;
      yq.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "travis";
  home.homeDirectory = "/home/travis";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes. You should not change this value,
  # even if you update Home Manager. If you do want to update the value, then
  # make sure to first check the Home Manager release notes.
  home.stateVersion = "25.11";
}
