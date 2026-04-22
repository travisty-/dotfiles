{
  flake.modules.homeManager.mpv = {config, ...}: let
    inherit (config.lib.file) mkOutOfStoreSymlink;
    inherit (config.meta) flake;
  in {
    programs.mpv = {
      enable = true;
    };

    xdg.configFile."mpv" = {
      source = mkOutOfStoreSymlink "${flake}/modules/features/programs/mpv";
      recursive = true;
    };
  };
}
