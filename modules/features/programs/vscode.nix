{
  flake.modules.homeManager.vscode = {
    programs.vscode = {
      enable = true;
    };

    internal.persistence = {
      home.directories = [
        ".config/Code"
        ".vscode"
      ];
    };
  };
}
