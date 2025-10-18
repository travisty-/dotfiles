{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.${namespace}.programs.mpv;
in {
  options.${namespace}.programs.mpv = {
    enable = mkEnableOption "mpv";
  };

  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
    };

    xdg.configFile."mpv" = {
      source = mkOutOfStoreSymlink "/etc/nixos/files/config/mpv";
      recursive = true;
    };
  };
}
