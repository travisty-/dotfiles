# https://wiki.nixos.org/wiki/OpenRGB
{
  flake.modules.nixos.disable-rgb = {pkgs, ...}: let
    disable-rgb = "${pkgs.openrgb}/bin/openrgb --noautoconnect --config /run --device NVIDIA --mode Direct --brightness 0";
  in {
    systemd.services.disable-rgb = {
      description = "Disable RGB on all specified devices.";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = disable-rgb;
        SuccessExitStatus = 255; # Cannot find device
        Type = "oneshot";
      };
    };

    powerManagement.resumeCommands = "${disable-rgb} || true";
  };
}
