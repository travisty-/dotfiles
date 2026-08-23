{inputs, ...}: {
  flake.modules.homeManager.neovim = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) attrValues concatLists;
    final = config.programs.neovim.finalPackage;
    lazygit = config.programs.lazygit.package;
    treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  in {
    imports = [inputs.self.modules.homeManager.nerd-fonts];

    programs.neovim = {
      enable = true;
      viAlias = false;
      vimAlias = false;
      vimdiffAlias = false;
      defaultEditor = false;
      sideloadInitLua = true;

      # We override what argv0 the wrapper binary uses so that anything that depends
      # on it (e.g. tmux-resurrect, tmux-continuum) doesn't see the /nix/store path.
      extraWrapperArgs = ["--argv0" "nvim"];

      # We install nvim-treesitter (with all grammars) via Nix so the plugin,
      # bundled queries, and parsers all share the same version and revision.
      plugins = with pkgs.vimPlugins; [markdown-preview-nvim treesitter];

      extraPackages = concatLists (attrValues (with pkgs; {
        formatters = [alejandra markdown-toc shfmt stylua];
        languages = [bash-language-server lua-language-server nil nixd];
        linters = [deadnix rumdl shellcheck statix];
        system = [curl git lazygit];
        toolchain = [fd fzf gcc ripgrep tree-sitter];
      }));
    };

    # We configure a dev override in lazy.nvim to source nvim-treesitter from
    # this symlink instead of fetching it from GitHub (see lua/config/nix.lua).
    xdg.dataFile."nvim/nix/nvim-treesitter" = {
      source = treesitter;
      recursive = true;
    };

    # Compatability shim for @astrojs/ts-plugin: https://github.com/LazyVim/LazyVim/discussions/6892
    xdg.dataFile."nvim/mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin" = {
      source = "${pkgs.astro-language-server}/lib/node_modules/astro-language-server/packages/language-tools/ts-plugin";
    };

    # Workaround to rename Neovim's default "wrapper" desktop entry.
    # https://discourse.nixos.org/t/make-neovim-wrapper-desktop-optional
    home.packages = [
      (lib.hiPrio (pkgs.runCommand "nvim.desktop" {} ''
        mkdir -p $out/share/applications
        substitute ${final}/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
          --replace-fail "Name=Neovim wrapper" "Name=Neovim"
      ''))
    ];
  };
}
