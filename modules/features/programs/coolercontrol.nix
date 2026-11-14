{
  flake.modules.nixos.coolercontrol = {pkgs, ...}: {
    programs.coolercontrol = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      liquidctl
      lm_sensors
    ];

    internal.persistence = {
      home.directories = [
        ".config/org.coolercontrol.CoolerControl"
        ".local/share/org.coolercontrol.CoolerControl"
      ];
      root.directories = [
        "/etc/coolercontrol"
        {
          directory = "/var/lib/coolercontrol";
          mode = "0711";
        }
      ];
    };
  };
}
