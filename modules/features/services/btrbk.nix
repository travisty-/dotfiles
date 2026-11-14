{
  flake.modules.nixos.btrbk = {config, ...}: {
    services.btrbk = {
      instances.btrbk = {
        onCalendar = "hourly";
        settings = {
          snapshot_preserve_min = "1w";
          snapshot_preserve = "2w";
          volume."/" = {
            snapshot_dir = "/.snapshots";
            subvolume =
              if config.preservation.enable or false
              then "persist"
              else "home";
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /.snapshots 0755 root root"
    ];
  };
}
