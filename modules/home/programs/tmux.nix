{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.tmux;
in {
  options.settings.programs.tmux = {
    enable = mkEnableOption "tmux";
  };

  # https://nixos.wiki/wiki/Tmux
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
    };
  };
}
