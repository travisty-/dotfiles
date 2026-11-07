{
  flake.modules.nixos.disable-rgb = {pkgs, ...}: {
    systemd.services.disable-rgb = {
      description = "Disable RGB on all specified devices.";
      wantedBy = ["multi-user.target" "suspend.target"];
      after = ["suspend.target"];
      environment.XDG_CONFIG_HOME = "/run/disable-rgb";
      serviceConfig = {
        ExecStart = "${pkgs.openrgb}/bin/openrgb --noautoconnect --device NVIDIA --mode Direct --brightness 0";
        SuccessExitStatus = 255; # Cannot find device
        Type = "oneshot";
      };
    };
  };
}
