{
  flake.modules.nixos.power-profiles = {
    services.power-profiles-daemon.enable = true;

    internal.persistence = {
      root.directories = [
        "/var/lib/power-profiles-daemon"
      ];
    };
  };
}
