{inputs, ...}: {
  flake.profiles.homeManager.cli = {
    imports = with inputs.self.modules.homeManager; [
      bind
      btop
      chafa
      chezmoi
      direnv
      eza
      fastfetch
      fd
      file
      fzf
      gum
      jq
      rclone
      ripgrep
      tabiew
      tmux
      trash
      tree
      yazi
      yq
      zoxide
    ];
  };
}
