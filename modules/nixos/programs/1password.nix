{
  # https://nixos.wiki/wiki/1Password
  flake.modules.nixos._1password = {config, ...}: let
    inherit (config.meta.user) username;
  in {
    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    # Certain features, including CLI integration and system authentication support,
    # require enabling polkit integration on some desktop environments (e.g. Plasma).
    programs._1password-gui.polkitPolicyOwners = [username];
  };
}
