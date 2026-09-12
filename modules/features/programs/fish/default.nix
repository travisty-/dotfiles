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

    xdg.configFile."fish/functions/fish_prompt.fish" = {
      source = ./functions/fish_prompt.fish;
    };

    xdg.configFile."fish/conf.d/00-async-prompt.fish" = {
      source = ./conf.d/00-async-prompt.fish;
    };
  };

  flake.modules.nixos.fish = {pkgs, ...}: {
    programs.fish.enable = true;
    environment.shells = [pkgs.fish];
    environment.pathsToLink = ["/share/fish"];
  };
}
