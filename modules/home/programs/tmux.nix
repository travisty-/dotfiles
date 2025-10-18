{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.tmux;
in {
  options.${namespace}.programs.tmux = {
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
