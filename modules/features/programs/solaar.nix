{
  flake.modules.homeManager.solaar = {pkgs, ...}: {
    home.packages = with pkgs; [
      solaar
    ];
  };

  flake.modules.nixos.solaar = {pkgs, ...}: {
    services.udev.packages = [pkgs.solaar];
  };
}
