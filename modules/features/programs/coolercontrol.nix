{
  flake.modules.nixos.coolercontrol = {pkgs, ...}: {
    programs.coolercontrol = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      liquidctl
      lm_sensors
    ];
  };
}
