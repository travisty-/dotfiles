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
        ryzen
        secure-boot
        solaar
        tailscale
      ]);

    meta.user = {
      description = "Travis Kinney";
      username = "travis";
      shell = pkgs.fish;
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "earth" "x86_64-linux";
}
