{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) any attrValues concatLists mkEnableOption mkIf optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.${namespace}.programs.jetbrains;
in {
  options.${namespace}.programs.jetbrains = {
    toolbox.enable = mkEnableOption "JetBrains Toolbox";
    datagrip.enable = mkEnableOption "JetBrains DataGrip";
    goland.enable = mkEnableOption "JetBrains GoLand";
    pycharm.enable = mkEnableOption "JetBrains PyCharm";
    rider.enable = mkEnableOption "JetBrains Rider";
    rustrover.enable = mkEnableOption "JetBrains RustRover";
  };

  # https://nixos.wiki/wiki/Jetbrains_Tools
  # https://wiki.nixos.org/wiki/Jetbrains_Tools
  # https://github.com/NixOS/nixpkgs/issues/240444
  config = let
    withOpts = pkg:
      pkg.override {
        vmopts = "-Dawt.toolkit.name=WLToolkit";
      };

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
        (optional cfg.toolbox.enable (withOpts jetbrains-toolbox))
        (optional cfg.datagrip.enable (withPlugins (withOpts jetbrains.datagrip)))
        (optional cfg.goland.enable (withPlugins (withOpts jetbrains.goland)))
        (optional cfg.pycharm.enable (withPlugins (withOpts jetbrains.pycharm)))
        (optional cfg.rider.enable (withPlugins (withOpts jetbrains.rider)))
        (optional cfg.rustrover.enable (withPlugins (withOpts jetbrains.rust-rover)))
      ];

    home.file.".ideavimrc" = mkIf (any (x: x.enable) (attrValues cfg)) {
      source = mkOutOfStoreSymlink "/etc/nixos/files/config/jetbrains/.ideavimrc";
    };
  };
}
