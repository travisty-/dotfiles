{
  flake.modules.nixos.base = {config, ...}: let
    inherit (config.meta) user;
  in {
    sops.secrets.USER_PASSWORD_HASH.neededForUsers = true;

    users.mutableUsers = false;
    users.defaultUserShell = user.shell;
    users.users.${user.username} = {
      isNormalUser = true;
      inherit (user) description;
      extraGroups = ["networkmanager" "wheel"];
      hashedPasswordFile = config.sops.secrets.USER_PASSWORD_HASH.path;
    };
    users.users.root.hashedPasswordFile = config.sops.secrets.USER_PASSWORD_HASH.path;
  };
}
