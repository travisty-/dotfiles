{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.anki;
in {
  options.settings.programs.anki = {
    enable = mkEnableOption "Anki";
  };

  config = mkIf cfg.enable {
    programs.anki = {
      enable = true;
    };
  };
}
