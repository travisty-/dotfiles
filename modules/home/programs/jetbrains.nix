{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatLists mkEnableOption optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.settings.programs.jetbrains;
in {
  options.settings.programs.jetbrains = {
    toolbox.enable = mkEnableOption "JetBrains Toolbox";
    datagrip.enable = mkEnableOption "JetBrains DataGrip";
    goland.enable = mkEnableOption "JetBrains GoLand";
    pycharm.enable = mkEnableOption "JetBrains PyCharm";
    rider.enable = mkEnableOption "JetBrains Rider";
  };

  # https://nixos.wiki/wiki/Jetbrains_Tools
  # https://wiki.nixos.org/wiki/Jetbrains_Tools
  # https://github.com/NixOS/nixpkgs/issues/240444
  config = let
    withPlugins = pkg:
      with pkgs.jetbrains; (
        plugins.addPlugins pkg [
          "ideavim"
          "nixidea"
          "vscode-keymap"
          "which-key"
        ]
      );
  in {
    home.packages = with pkgs;
      concatLists [
        (optional cfg.toolbox.enable jetbrains-toolbox)
        (optional cfg.datagrip.enable (withPlugins jetbrains.datagrip))
        (optional cfg.goland.enable (withPlugins jetbrains.goland))
        (optional cfg.pycharm.enable (withPlugins jetbrains.pycharm-professional))
        (optional cfg.rider.enable (withPlugins jetbrains.rider))
      ];

    home.file.".ideavimrc" = {
      source = mkOutOfStoreSymlink "/etc/nixos/files/config/jetbrains/.ideavimrc";
    };
  };
}
