{inputs, ...}: {
  flake.modules.nixos.base = {config, ...}: let
    inherit (config.networking) hostName;
  in {
    hardware.facter = {
      reportPath = inputs.self + "/modules/systems/${hostName}/facter.json";
      detected.dhcp.enable = !config.networking.networkmanager.enable;
    };
  };
}
