{
  flake.modules.homeManager.editorconfig = {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          insert_final_newline = true;
          trim_trailing_whitespace = true;
        };
        "*.md" = {
          trim_trailing_whitespace = false;
        };
      };
    };
  };
}
