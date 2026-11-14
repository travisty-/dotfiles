{inputs, ...}: {
  flake.modules.nixos.preservation = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.internal) persistence;
    inherit (config.meta.user) username;
    inherit (config.networking) hostName;
    inherit (config.users.users.${username}) home;

    homeConfiguration = inputs.self.homeConfigurations."${username}@${hostName}";
    fromHomeManager = homeConfiguration.config.internal.persistence;

    # Entries for one scope (root or home), on both supported classes (NixOS and Home Manager).
    entriesFor = scope: {
      directories = (persistence.${scope}.directories ++ fromHomeManager.${scope}.directories) |> map (keepMode "directory");
      files = (persistence.${scope}.files ++ fromHomeManager.${scope}.files) |> map (keepMode "file");
    };

    # Unset modes keep what's on disk instead of using Preservation's defaults (0755 for folders, 0644 for files).
    keepMode = key: entry: {mode = "-";} // lib.optionalAttrs (lib.isString entry) {${key} = entry;} // lib.optionalAttrs (lib.isAttrs entry) entry;

    # Recursively walks through the folders above the specified path, up to home.
    parents = path: lib.optionals (dirOf path != ".") ([(dirOf path)] ++ parents (dirOf path));
  in {
    imports = [inputs.preservation.nixosModules.preservation];

    fileSystems."/persist".neededForBoot = true;

    preservation = {
      enable = true;
      preserveAt."/persist" = {
        commonMountOptions = ["x-gvfs-hide" "x-gvfs-trash"];
        directories =
          [
            {
              directory = "/var/lib/nixos";
              inInitrd = true;
            }
            {
              directory = "/var/lib/pcrlock.d";
              inInitrd = true;
            }
            {
              directory = "/var/lib/systemd";
              inInitrd = true;
            }
          ]
          ++ (entriesFor "root").directories;
        files =
          [
            {
              file = "/etc/machine-id";
              inInitrd = true;
              mode = "0444";
            }
          ]
          ++ (entriesFor "root").files;
        users.${username} = entriesFor "home";
      };
    };

    # Modifies existing parent folders of home entries to private (0700) instead of the default (0755).
    systemd.tmpfiles.settings.preservation =
      lib.attrValues (entriesFor "home")
      |> lib.concatLists
      |> lib.concatMap (entry: parents (entry.directory or entry.file))
      |> lib.concatMap (path: ["${home}/${path}" "/persist${home}/${path}"])
      |> lib.flip lib.genAttrs (_: {d.mode = lib.mkOverride 99 "0700";});

    # Activates and links the current Home Manager generation at boot before login.
    systemd.services.home-manager-activate = {
      description = "Activate the current Home Manager generation";
      wantedBy = ["multi-user.target"];
      wants = ["nix-daemon.socket"];
      after = ["nix-daemon.socket"];
      before = ["systemd-user-sessions.service"];
      restartIfChanged = false; # Runs once per boot.
      unitConfig.RequiresMountsFor = home;
      environment.GIO_USE_VFS = "local"; # Avoids an orphaned GVFS mount on ~/.gvfs.
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutStartSec = "5m";
        User = username;
        ExecStart = "${pkgs.runtimeShell} -lc 'exec ${home}/.local/state/nix/profiles/home-manager/activate --driver-version 1'";
      };
    };

    environment.loginShellInit = ''
      if systemctl --quiet is-failed home-manager-activate.service; then
        echo "Warning: Home Manager failed to activate at boot. See 'journalctl --boot --unit home-manager-activate'." >&2
      fi
    '';

    # Skips the pcrlock policy update unless its persisted state was mounted. Otherwise, the missing
    # policy would be rebuilt from scratch and the TPM would no longer be able to unlock the disk.
    systemd.services.systemd-pcrlock-make-policy.unitConfig.ConditionPathIsMountPoint = [
      "/var/lib/pcrlock.d"
      "/var/lib/systemd"
    ];

    # /etc/machine-id is persisted, so systemd doesn't need to commit one.
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  };
}
