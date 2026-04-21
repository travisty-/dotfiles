{
  # https://docs.coolercontrol.org/installation/nix.html
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
