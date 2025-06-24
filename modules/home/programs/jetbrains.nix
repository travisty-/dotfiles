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
  config = {
    home.packages = with pkgs;
      concatLists [
        (optional cfg.toolbox.enable jetbrains-toolbox)
        (optional cfg.datagrip.enable jetbrains.datagrip)
        (optional cfg.goland.enable jetbrains.goland)
        (optional cfg.pycharm.enable jetbrains.pycharm-professional)
        (optional cfg.rider.enable jetbrains.rider)
      ];

    home.file.".ideavimrc" = {
      source = mkOutOfStoreSymlink "/etc/nixos/files/config/jetbrains/.ideavimrc";
    };
  };
}
