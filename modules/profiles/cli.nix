{inputs, ...}: {
  flake.profiles.homeManager.cli = {
    imports = with inputs.self.modules.homeManager; [
      bind
      btop
      chezmoi
      direnv
      eza
      fastfetch
      fd
      file
      fzf
      jq
      ripgrep
      tabiew
      tmux
      trash
      tree
      yazi
      yq
      zellij
      zoxide
    ];
  };
}
