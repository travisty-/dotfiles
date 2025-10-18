{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.anki;
in {
  options.${namespace}.programs.anki = {
    enable = mkEnableOption "Anki";
  };

  config = mkIf cfg.enable {
    programs.anki = {
      enable = true;
    };
  };
}
