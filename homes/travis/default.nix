{
  inputs,
  lib,
  ...
}:
with lib.extensions; {
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
      _1password = enabled;
      alacritty = enabled;
      deadnix = enabled;
      devenv = enabled;
      direnv = enabled;
      discord = enabled;
      eza = enabled;
      fastfetch = enabled;
      fd = enabled;
      firefox = enabled;
      fzf = enabled;
      gh = enabled;
      ghostty = enabled;
      git = enabled;
      jq = enabled;
      just = enabled;
      mpv = enabled;
      neovim = enabled;
      obsidian = enabled;
      powershell = enabled;
      qbittorrent = enabled;
      remmina = enabled;
      ripgrep = enabled;
      sops = enabled;
      statix = enabled;
      subtitleedit = enabled;
      tree = enabled;
      vscode = enabled;
      yq = enabled;
      zoxide = enabled;
      zsh = enabled;
    };

    programs.jetbrains = {
      toolbox = disabled;
      datagrip = enabled;
      goland = enabled;
      pycharm = enabled;
      rider = enabled;
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
