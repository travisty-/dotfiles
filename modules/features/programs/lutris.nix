{
  flake.modules.nixos.lutris = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      lutris
    ];

    internal.persistence = {
      home.directories = [
        ".local/share/lutris"
      ];
    };
  };
}
