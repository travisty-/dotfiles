{inputs, ...}: {
  flake.profiles.homeManager.cli = {
    imports = with inputs.self.modules.homeManager; [
      bind
      bottom
      btop
      chafa
      chezmoi
      direnv
      dust
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
