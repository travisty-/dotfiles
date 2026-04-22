{
  flake.modules.homeManager.jetbrains = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) any attrValues concatLists mkEnableOption mkIf optional;
    inherit (config.lib.file) mkOutOfStoreSymlink;
    inherit (config.meta) flake;
    cfg = config.internal.programs.jetbrains;
  in {
    options.internal.programs.jetbrains = {
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
    in {
      home.packages = with pkgs;
        concatLists [
          (optional cfg.toolbox.enable (withOpts jetbrains-toolbox))
          (optional cfg.datagrip.enable (withOpts jetbrains.datagrip))
          (optional cfg.goland.enable (withOpts jetbrains.goland))
          (optional cfg.pycharm.enable (withOpts jetbrains.pycharm))
          (optional cfg.rider.enable (withOpts jetbrains.rider))
          (optional cfg.rustrover.enable (withOpts jetbrains.rust-rover))
        ];

      home.file.".ideavimrc" = mkIf (any (x: x.enable) (attrValues cfg)) {
        source = mkOutOfStoreSymlink "${flake}/modules/features/programs/jetbrains/.ideavimrc";
      };
    };
  };
}
