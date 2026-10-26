{inputs, ...}: {
  flake.modules.nixos.earth = {pkgs, ...}: {
    imports =
      (with inputs.self.profiles.nixos; [
        desktop
        development
        gaming
        media
        shell
      ])
      ++ (with inputs.self.modules.nixos; [
        base
        _1password
        bluetooth
        btrbk
        coolercontrol
        disable-rgb
        i2c
        disko
        firefox
        fstrim
        keyd
        networking
        nix-helpers
        nvidia
        openrgb
        openssh
        power-profiles
        printing
        restic
        secure-boot
        solaar
        tailscale
      ]);

    meta.user = {
      description = "Travis Kinney";
      username = "travis";
      shell = pkgs.fish;
    };

    services.pipewire.wireplumber.extraConfig.devices."monitor.alsa.rules" = [
      {
        matches = [
          {"device.product.name" = "GA102 High Definition Audio Controller";}
          {"device.product.name" = "Starship/Matisse HD Audio Controller";}
        ];
        actions.update-props."device.disabled" = true;
      }
      {
        matches = [{"node.name" = "alsa_output.usb-Audioengine_Audioengine_2_-00.analog-stereo";}];
        actions.update-props."node.description" = "Audioengine A2+";
      }
    ];
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "earth" "x86_64-linux";
}
