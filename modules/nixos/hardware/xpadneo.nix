{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.hardware.xpadneo;
in {
  options.${namespace}.hardware.xpadneo = {
    enable = mkEnableOption "xpadneo";
  };

  config = mkIf cfg.enable {
    hardware.xpadneo.enable = true;

    # Disable HIDAPI to force SDL to use xpadneo's evdev interface.
    environment.sessionVariables = {
      SDL_JOYSTICK_HIDAPI_XBOX = "0";
      SDL_JOYSTICK_HIDAPI_XBOX_ONE = "0";
    };
  };
}
