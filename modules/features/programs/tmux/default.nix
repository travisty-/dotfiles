{
  flake.modules.homeManager.tmux = {pkgs, ...}: let
    scripts = import ./_scripts.nix {inherit pkgs;};
  in {
    programs.tmux = {
      enable = true;
      focusEvents = true;
      mouse = true;

      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;

      prefix = "C-a";
      keyMode = "vi";
      terminal = "tmux-256color";

      plugins = with pkgs.tmuxPlugins; [
        sensible
        {
          plugin = dotbar;
          extraConfig = ''
            set -g @tmux-dotbar-bg "default"
            set -g @tmux-dotbar-bold-current-window true
            set -g @tmux-dotbar-status-right "#(${scripts}/bin/tmux-claude-statusline.py)"
            set -g @tmux-dotbar-right true
            set -g @tmux-dotbar-window-status-format " #{?#{==:#{window_name},claude},#[fg=#da7756]󰚩 #W,#W} "
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-pane-contents-area 'visible'
            set -g @resurrect-processes '"nvim->nvim -c \"lua require([[persistence]]).load()\""'
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
        {
          # https://github.com/smart-splits-nvim/backend-tmux
          plugin = mkTmuxPlugin {
            pluginName = "smart-splits";
            version = "0-unstable-2026-10-02";
            rtpFilePath = "smart-splits.tmux";
            src = pkgs.fetchFromGitHub {
              owner = "smart-splits-nvim";
              repo = "backend-tmux";
              rev = "9e9e6aa9b3eb7a8d3896a993611622ac97abff52";
              hash = "sha256-RcJdM6wFHZOEOK+cXVIT10anktqGgIilPmojFpdY+4g=";
            };
          };
          extraConfig = ''
            set -g @smart-splits_at_edge 'stop'
          '';
        }
      ];
      extraConfig = ''
        # Enable true color in supported terminals.
        set -as terminal-features ",xterm-256color:RGB"

        # Use terminal ANSI colors.
        set -g theme terminal

        # Set the status line style for the currently active window.
        set -g window-status-current-style default

        # Use the terminal's default colors for menus, popups, and panes.
        set -g menu-style default
        set -g menu-border-style default
        set -g popup-style default
        set -g popup-border-style default
        set -g pane-border-style default

        # Batch redraws so the terminal never paints a half-drawn frame. (DEC 2026)
        # https://github.com/contour-terminal/vt-extensions/blob/master/synchronized-output.md
        set -as terminal-features ",xterm-256color:sync"

        # Allow programs to pass escape sequences to the outer terminal. (DCS)
        # https://code.claude.com/docs/en/terminal-config#configure-tmux
        set -g allow-passthrough on
        set -s extended-keys on
        set -as terminal-features ",xterm*:extkeys"

        # Renumber windows to close gaps in the window list.
        set -g renumber-windows on

        # Use the size of the largest attached client.
        set -g window-size largest

        # Use vi key bindings at the command prompt.
        set -g status-keys vi

        # Increase maximum length of left and right status lines.
        set -g status-left-length 100
        set -g status-right-length 100

        # Open new windows and splits in the current pane's working directory.
        bind -N "Create a new window" c new-window -c "#{pane_current_path}"
        bind -N "Split window vertically" '"' split-window -v -c "#{pane_current_path}"
        bind -N "Split window horizontally" % split-window -h -c "#{pane_current_path}"

        # Open `choose-tree` in a centered modal pane.
        bind -N "Choose a session" s 'new-pane -CEO -x50% -y45%; move-pane -P centre; choose-tree -Nhks -O name'
        bind -N "Choose a window" w 'new-pane -CEO -x50% -y45%; move-pane -P centre; choose-tree -Nhkw -O name'

        # Open `switch-mode` in a centered modal pane.
        bind -N "Switch to a window" Tab 'new-pane -CEO -x50% -y45%; move-pane -P centre; switch-mode -kw'
        bind -N "Switch to a session" BTab 'new-pane -CEO -x50% -y45%; move-pane -P centre; switch-mode -ks'

        # Open the Claude Code agents dashboard in a floating popup.
        bind -N "Open the agents dashboard" A display-popup -E -w 75% -h 75% ${scripts}/bin/tmux-claude-dashboard.py
        bind -n MouseDown1StatusRight display-popup -E -w 75% -h 75% ${scripts}/bin/tmux-claude-dashboard.py

        # Launch Claude Code in a new window.
        bind -N "Open the Claude Code menu" C-c display-menu -T " #[align=centre]Claude Code " -x C -y C \
          "New session"      n "new-window -c '#{pane_current_path}' 'exec claude'" \
          "Resume session"   r "new-window -c '#{pane_current_path}' 'exec claude --resume'" \
          "Continue session" c "new-window -c '#{pane_current_path}' 'exec claude --continue'"

        # Include key bindings without notes in list.
        bind -N "List key bindings" ? list-keys -Na

        # Restore the default readline key binding for clearing the screen (`<C-l>`).
        # `<C-l>` is also used for navigation in nvim/tmux, so we relay it via `<F48>`.
        bind -N "Clear screen" C-l if -F '#{@pane-is-vim}' { send-keys C-S-F12 } { send-keys C-l }
      '';
    };
  };
}
