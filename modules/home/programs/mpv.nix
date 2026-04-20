{
  flake.modules.homeManager.mpv = {config, ...}: let
    inherit (config.lib.file) mkOutOfStoreSymlink;
  in {
    programs.mpv = {
      enable = true;
    };

    xdg.configFile."mpv" = {
      source = mkOutOfStoreSymlink "/etc/nixos/files/config/mpv";
      recursive = true;
    };
  };
}
