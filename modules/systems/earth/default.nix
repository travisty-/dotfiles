{inputs, ...}: {
  flake.modules.nixos.earth = {
    imports =
      (with inputs.self.profiles.nixos; [
        desktop
        gaming
      ])
      ++ (with inputs.self.modules.nixos; [
        base
        _1password
        bluetooth
        coolercontrol
        disko
        docker
        firefox
        fstrim
        networking
        nix-helpers
        nvidia
        openrgb
        openssh
        power-profiles
        printing
        ryzen
        secure-boot
        spotify
        tailscale
        virt-manager
        zsh
      ]);

    meta.user = {
      description = "Travis Kinney";
      username = "travis";
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "earth";
}
