{inputs, ...}: {
  flake.modules.nixos.earth = {
    imports =
      (with inputs.self.profiles.nixos; [
        desktop
        development
        gaming
        terminal
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
        networking
        nix-helpers
        nvidia
        openrgb
        openssh
        power-profiles
        printing
        restic
        ryzen
        secure-boot
        solaar
        spotify
        tailscale
      ]);

    meta.user = {
      description = "Travis Kinney";
      username = "travis";
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "earth" "x86_64-linux";
}
