{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs._1password;
in {
  options.settings.programs._1password = {
    enable = mkEnableOption "1Password";
  };

  # https://nixos.wiki/wiki/1Password
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
            IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
