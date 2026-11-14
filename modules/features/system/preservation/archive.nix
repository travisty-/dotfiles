{
  flake.modules.nixos.preservation = {
    config,
    lib,
    pkgs,
    utils,
    ...
  }: let
    inherit (config.fileSystems."/") device;
    deviceUnit = "${utils.escapeSystemdPath device}.device";
    subvolumes =
      ["/" "/home"]
      |> lib.filter (mount: config.fileSystems ? ${mount})
      |> map (mount:
        config.fileSystems.${mount}.options
        |> lib.findFirst (lib.hasPrefix "subvol=") null
        |> lib.removePrefix "subvol=");
  in {
    boot.initrd.systemd.services.archive-roots = {
      description = "Archive previous root subvolumes";
      wantedBy = ["initrd.target"];
      requires = [deviceUnit];
      after = [deviceUnit "local-fs-pre.target"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = false;
      enableStrictShellChecks = true;
      serviceConfig = {
        Type = "oneshot";
        PrivateMounts = true;
        RemainAfterExit = true; # Don't rerun if initrd.target is restarted
        RuntimeDirectory = "archive-roots";
      };
      script = ''
        mount --options subvolid=5 ${device} "$RUNTIME_DIRECTORY"
        roots=$RUNTIME_DIRECTORY/roots
        mkdir --parents "$roots"
        archive=$roots/$(date --utc +%Y%m%dT%H%M%SZ)
        btrfs subvolume create "$archive"
        for subvolume in ${lib.escapeShellArgs subvolumes}; do
          btrfs subvolume create "$archive/$subvolume"
          mv --exchange --no-target-directory --verbose "$archive/$subvolume" "$RUNTIME_DIRECTORY/$subvolume"
        done
      '';
    };

    systemd.services.prune-archived-roots = {
      description = "Prune archived root subvolumes";
      wantedBy = ["multi-user.target"];
      path = [pkgs.btrfs-progs pkgs.util-linux];
      enableStrictShellChecks = true;
      serviceConfig = {
        Type = "oneshot";
        PrivateMounts = true;
        RuntimeDirectory = "prune-archived-roots";
      };
      script = ''
        mount --options subvolid=5 ${device} "$RUNTIME_DIRECTORY"
        roots=$RUNTIME_DIRECTORY/roots
        cutoff=$roots/$(date --utc --date='30 days ago' +%Y%m%dT%H%M%SZ)
        shopt -s nullglob && archives=("$roots"/*)
        for ((i = 0; i < ''${#archives[@]} - 5; i++)); do
          [[ ''${archives[i]} < $cutoff ]] || break
          btrfs subvolume delete --recursive "''${archives[i]}"
        done
      '';
    };
  };
}
