{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.fastfetch;
in {
  options.${namespace}.programs.fastfetch = {
    enable = mkEnableOption "Fastfetch";
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
    };

    home.shellAliases = {
      ff = "fastfetch";
    };
  };
}
