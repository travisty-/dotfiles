{
  flake.modules.nixos.base = {config, ...}: let
    inherit (config.meta) user;
  in {
    users.defaultUserShell = user.shell;
    users.users.${user.username} = {
      isNormalUser = true;
      inherit (user) description;
      extraGroups = ["networkmanager" "wheel"];
    };
  };
}
