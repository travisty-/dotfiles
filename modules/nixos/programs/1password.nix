{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.meta.user) username;
  cfg = config.${namespace}.programs._1password;
in {
  options.${namespace}.programs._1password = {
    enable = mkEnableOption "1Password";
  };

  # https://nixos.wiki/wiki/1Password
  config = mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    # Certain features, including CLI integration and system authentication support,
    # require enabling polkit integration on some desktop environments (e.g. Plasma).
    programs._1password-gui.polkitPolicyOwners = [username];
  };
}
