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
        disable-rgb
        disko
        docker
        firefox
        fish
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

  flake.nixosConfigurations = inputs.self.lib.mkNixos "earth" "x86_64-linux";
}
