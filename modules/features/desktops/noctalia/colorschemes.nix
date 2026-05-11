# Pattern: colorschemes/<name>/<name>.json
# via settings.colorschemes.predefinedScheme
{
  flake.modules.homeManager.noctalia = {
    xdg.configFile."noctalia/colorschemes" = {
      source = ./colorschemes;
      recursive = true;
    };
  };
}
