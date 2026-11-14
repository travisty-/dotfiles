{
  flake.modules.homeManager.solaar = {pkgs, ...}: {
    home.packages = with pkgs; [
      solaar
    ];

    internal.persistence = {
      home.directories = [
        ".config/solaar"
      ];
    };
  };

  flake.modules.nixos.solaar = {pkgs, ...}: {
    services.udev.packages = [pkgs.solaar];
  };
}
