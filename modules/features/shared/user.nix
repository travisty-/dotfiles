{
  flake.modules.nixos.base = {
    config,
    pkgs,
    ...
  }: let
    user = config.meta.user;
  in {
    users.defaultUserShell = user.shell;
    users.users.${user.username} = {
      isNormalUser = true;
      description = user.description;
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        # thunderbird
      ];
    };
  };
}
