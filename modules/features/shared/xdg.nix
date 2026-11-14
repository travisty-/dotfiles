{
  flake.modules.homeManager.base = {
    xdg = {
      enable = true;
      mimeApps.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        projects = null;
        publicShare = null;
      };
    };

    # User-specific executables (XDG Base Directory Specification 0.8+).
    home.sessionPath = ["$HOME/.local/bin"];

    internal.persistence = {
      home.directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Templates"
        "Videos"
      ];
    };
  };
}
