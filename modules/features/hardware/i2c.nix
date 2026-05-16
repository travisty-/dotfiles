{
  flake.modules.nixos.i2c = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.meta.user) username;
  in {
    hardware.i2c.enable = true;
    environment.systemPackages = [pkgs.ddcutil];
    users.users.${username}.extraGroups = ["i2c"];
  };
}
