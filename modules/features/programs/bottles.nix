{
  flake.modules.nixos.bottles = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
