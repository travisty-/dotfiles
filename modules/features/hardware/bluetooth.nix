{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;

      # Show battery charge of connected Bluetooth devices.
      settings.general.experimental = true;
    };

    internal.persistence = {
      root.directories = [
        {
          directory = "/var/lib/bluetooth";
          mode = "0700";
        }
      ];
    };
  };
}
