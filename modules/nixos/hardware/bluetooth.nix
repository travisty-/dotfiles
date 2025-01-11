{
  config,
  pkgs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;

    # Show battery charge of connected Bluetooth devices.
    settings.general.experimental = true;
  };
}
