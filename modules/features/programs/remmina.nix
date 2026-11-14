{
  flake.modules.homeManager.remmina = {pkgs, ...}: {
    home.packages = with pkgs; [
      remmina
    ];

    internal.persistence = {
      home.directories = [
        ".config/freerdp"
        ".config/remmina"
      ];
    };
  };
}
