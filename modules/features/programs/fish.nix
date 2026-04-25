{
  flake.modules.homeManager.fish = {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };

    home.sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  flake.modules.nixos.fish = {pkgs, ...}: {
    programs.fish.enable = true;
    environment.shells = [pkgs.fish];
    environment.pathsToLink = ["/share/fish"];
  };
}
