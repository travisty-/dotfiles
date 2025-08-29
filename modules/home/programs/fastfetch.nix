{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.fastfetch;
in {
  options.settings.programs.fastfetch = {
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
