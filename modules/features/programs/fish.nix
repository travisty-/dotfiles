{
  flake.modules.homeManager.fish = {pkgs, ...}: {
    programs.fish = {
      enable = true;

      binds."ctrl-h".command = "backward-kill-word";

      interactiveShellInit = ''
        set -g fish_greeting
      '';

      plugins =
        map (name: {
          inherit name;
          src = pkgs.fishPlugins.${name}.src;
        }) [
          "async-prompt"
          "autopair"
          "fish-you-should-use"
          "puffer"
          "sponge"
        ];
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
