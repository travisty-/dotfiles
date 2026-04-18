{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.neovim;
  final = config.programs.neovim.finalPackage;
in {
  options.${namespace}.programs.neovim = {
    enable = mkEnableOption "Neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = false;
      vimAlias = false;
      vimdiffAlias = false;
      defaultEditor = false;
      sideloadInitLua = true;
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
