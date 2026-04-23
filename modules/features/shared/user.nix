{
  flake.modules.nixos.base = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.meta) user;
  in {
    users.defaultUserShell = user.shell;
    users.users.${user.username} = {
      isNormalUser = true;
      inherit (user) description;
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        # thunderbird
      ];
    };
  };
}
