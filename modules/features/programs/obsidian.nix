{
  flake.modules.homeManager.obsidian = {pkgs, ...}: {
    home.packages = with pkgs; [
      obsidian
    ];

    internal.persistence = {
      home.directories = [
        ".config/obsidian"
      ];
    };
  };
}
