{
  flake.modules.homeManager.tmux = {
    lib,
    pkgs,
    ...
  }: {
    programs.tmux = {
      enable = true;
      focusEvents = true;
      sensibleOnTop = true;
      mouse = true;

      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;

      prefix = "C-a";
      keyMode = "vi";
      terminal = "tmux-256color";

      plugins = with pkgs.tmuxPlugins; [
        {
          # https://github.com/NixOS/nixpkgs/pull/511304
          plugin = assert lib.assertMsg (lib.versionOlder dotbar.version "0.3.3")
          "tmuxPlugins.dotbar.version: ${dotbar.version} (>= 0.3.3)";
            dotbar.overrideAttrs (_: {
              version = "0.3.3";
              src = pkgs.fetchFromGitHub {
                owner = "vaaleyard";
                repo = "tmux-dotbar";
                tag = "0.3.3";
                hash = "sha256-CAKEN8Sk3t0nonV2R9df/DFTTUrVnbso0ZVGgeeGINM=";
              };
            });
          extraConfig = ''
            set -g @tmux-dotbar-bg "default"
            set -g @tmux-dotbar-bold-current-window true
          '';
        }
        {
          plugin = resurrect.overrideAttrs (_: {
            src = pkgs.fetchFromGitHub {
              owner = "travisty-";
              repo = "tmux-resurrect";
              rev = "97365d7bca848b7e836f13a85d4ecda2f3d7efa3";
              hash = "sha256-SUk3MNYn5DFKsTp1TBiAgvkAnOB4ZF4kNjkACpx4U9E=";
              fetchSubmodules = true;
            };
          });
          extraConfig = ''
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-pane-contents-area 'visible'
            set -g @resurrect-strategy-nvim 'persistence'
            set -g @resurrect-dir '~/.local/share/tmux/resurrect';
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-restore-max-delay '30'
          '';
        }
        {
          # https://github.com/NixOS/nixpkgs/issues/376560
          plugin = tmux-which-key;
          extraConfig = ''
            set -g @tmux-which-key-xdg-enable 1
            set -g @tmux-which-key-disable-autobuild 1
          '';
        }
        fingers
        yank
      ];
      extraConfig = ''
        # Enable true color in supported terminals.
        set -as terminal-features ",xterm-256color:RGB"

        # Allow programs to pass escape sequeances to the outer terminal. (DCS)
        set -g allow-passthrough on

        # Renumber windows to close gaps in the window list.
        set -g renumber-windows on

        # Increase maximum length of left and right status lines.
        set -g status-left-length 100
        set -g status-right-length 100

        # Open new windows and splits in the current pane's working directory.
        bind -N "Create a new window" c new-window -c "#{pane_current_path}"
        bind -N "Split window vertically" '"' split-window -v -c "#{pane_current_path}"
        bind -N "Split window horizontally" % split-window -h -c "#{pane_current_path}"

        # Open `choose-tree` with the larger preview pane.
        bind -N "Choose a session" s choose-tree -sNNZ
        bind -N "Choose a window" w choose-tree -wNNZ

        # https://github.com/tmux/tmux/issues/5056
        # bind -N "Choose a session" s 'new-pane -kE -X25% -Y27% -x50% -y45%; choose-tree -Nskh'
        # bind -N "Choose a window" w 'new-pane -kE -X25% -Y27% -x50% -y45%; choose-tree -Nwkh'

        # Include key bindings without notes in list.
        bind -N "List key bindings" ? list-keys -Na

        # Keybindings for smart-splits.nvim: https://github.com/NixOS/nixpkgs/pull/505204
        # Smart directional navigation with awareness of Neovim splits (wrapping disabled).
        bind -n C-h if -F '#{@pane-is-vim}' { send-keys C-h } { if -F '#{pane_at_left}'   "" 'select-pane -L' }
        bind -n C-j if -F '#{@pane-is-vim}' { send-keys C-j } { if -F '#{pane_at_bottom}' "" 'select-pane -D' }
        bind -n C-k if -F '#{@pane-is-vim}' { send-keys C-k } { if -F '#{pane_at_top}'    "" 'select-pane -U' }
        bind -n C-l if -F '#{@pane-is-vim}' { send-keys C-l } { if -F '#{pane_at_right}'  "" 'select-pane -R' }

        # Smart pane resizing with awareness of Neovim splits.
        bind -n C-Up    if -F '#{@pane-is-vim}' { send-keys C-Up }    { resize-pane -U 5 }
        bind -n C-Down  if -F '#{@pane-is-vim}' { send-keys C-Down }  { resize-pane -D 5 }
        bind -n C-Left  if -F '#{@pane-is-vim}' { send-keys C-Left }  { resize-pane -L 5 }
        bind -n C-Right if -F '#{@pane-is-vim}' { send-keys C-Right } { resize-pane -R 5 }

        # Smart copy mode with awareness of Neovim splits.
        bind -T copy-mode-vi C-h select-pane -L
        bind -T copy-mode-vi C-j select-pane -D
        bind -T copy-mode-vi C-k select-pane -U
        bind -T copy-mode-vi C-l select-pane -R

        # Restore the default readline key binding for clearing the screen (`<C-l>`).
        # `<C-l>` is also used for navigation in nvim/tmux, so we relay it via `<F48>`.
        bind -N "Clear screen" C-l if -F '#{@pane-is-vim}' { send-keys C-S-F12 } { send-keys C-l }
      '';
    };
  };
}
