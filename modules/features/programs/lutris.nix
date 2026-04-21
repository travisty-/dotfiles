{
  # https://nixos.wiki/wiki/Lutris
  flake.modules.nixos.lutris = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
