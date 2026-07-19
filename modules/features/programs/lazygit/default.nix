{
  flake.modules.homeManager.lazygit = {pkgs, ...}: let
    scripts = import ./_scripts.nix {inherit pkgs;};
  in {
    programs.lazygit = {
      enable = true;
      settings = {
        customCommands = [
          {
            key = "A";
            context = "commits";
            description = "Amend (custom)";
            command = "${scripts}/bin/amend-commit {{.SelectedCommit.Hash}}";
            output = "log";
            loadingText = "Amending";
            after = {
              checkForConflicts = true;
            };
            prompts = [
              {
                type = "confirm";
                title = "Amend commit (custom)";
                body = "Are you sure you want to amend this commit with your staged files?";
              }
            ];
          }
        ];
      };
    };
  };
}
