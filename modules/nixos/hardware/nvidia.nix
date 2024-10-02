{
  config,
  pkgs,
  ...
}: {
  # Enable hardware accelerated graphics.
  hardware.graphics.enable = true;

  # Load Nvidia drivers for XOrg and Wayland.
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management is experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes
    # after waking up from sleep. This fixes the issue by saving the entire VRAM
    # memory to /tmp instead of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management turns off the GPU when not in use. This is
    # experimental, and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the Nvidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver). Support is limited
    # to modern Nvidia GPUs (Turing or newer). Only available from driver 515.43.04+.
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
