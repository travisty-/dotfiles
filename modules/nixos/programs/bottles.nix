{
  # https://wiki.nixos.org/wiki/Bottles
  flake.modules.nixos.bottles = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
