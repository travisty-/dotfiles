{
  flake.modules.homeManager.devenv = {pkgs, ...}: {
    home.packages = with pkgs; [
      devenv
    ];

    internal.persistence = {
      home.directories = [
        ".local/share/devenv"
      ];
    };
  };
}
