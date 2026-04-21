{
  flake.modules.nixos.xpadneo = {
    hardware.xpadneo.enable = true;

    # Disable HIDAPI to force SDL to use xpadneo's evdev interface.
    environment.sessionVariables = {
      SDL_JOYSTICK_HIDAPI_XBOX = "0";
      SDL_JOYSTICK_HIDAPI_XBOX_ONE = "0";
    };
  };
}
