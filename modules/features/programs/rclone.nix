{
  flake.modules.homeManager.rclone = {
    programs.rclone.enable = true;

    internal.persistence = {
      home.directories = [
        ".config/rclone"
      ];
    };
  };
}
