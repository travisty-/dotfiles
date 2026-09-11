{
  flake.modules.nixos.earth = let
    mountOptions = ["compress=zstd" "noatime" "x-gvfs-trash"];
  in {
    disko.devices.disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S6B0NG0RA42155D";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0077" "dmask=0077"];
              };
            };
            root = {
              label = "root";
              size = "100%";
              content = {
                type = "luks";
                name = "luks-17bc8fc5-5592-487f-a697-f738403676b0";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "@" = {
                      inherit mountOptions;
                      mountpoint = "/";
                    };
                    "@home" = {
                      inherit mountOptions;
                      mountpoint = "/home";
                    };
                    "@nix" = {
                      inherit mountOptions;
                      mountpoint = "/nix";
                    };
                    "@log" = {
                      inherit mountOptions;
                      mountpoint = "/var/log";
                    };
                  };
                };
              };
            };
          };
        };
      };
      nvme1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S6B0NG0R719985N";
        content = {
          type = "gpt";
          partitions = {
            data = {
              label = "data";
              size = "100%";
              content = {
                type = "luks";
                name = "luks-3426c936-e49d-48fa-9e41-ca1be20ce3a1";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "@data" = {
                      mountpoint = "/media/data";
                      mountOptions = mountOptions ++ ["x-gvfs-hide"];
                    };
                    "@games" = {
                      mountpoint = "/media/games";
                      mountOptions = mountOptions ++ ["x-gvfs-hide"];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
