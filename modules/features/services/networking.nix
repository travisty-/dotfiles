{
  flake.modules.nixos.networking = {
    networking.networkmanager.enable = true;

    internal.persistence = {
      root.directories = [
        {
          directory = "/etc/NetworkManager/system-connections";
          mode = "0700";
        }
        "/var/lib/NetworkManager"
      ];
    };
  };
}
