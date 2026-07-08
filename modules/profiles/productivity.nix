{inputs, ...}: {
  flake.profiles.homeManager.productivity = {
    imports = with inputs.self.modules.homeManager; [
      anki
      obsidian
      raindrop
    ];
  };
}
