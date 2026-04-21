{
  flake.modules.nixos.base = {
    config,
    pkgs,
    ...
  }: let
    user = config.meta.user;
  in {
    # Define a user account. Don't forget to set a password with 'passwd'!
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
