{
  flake.modules.homeManager.helix = {pkgs, ...}: {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [nil nixd];
      settings = {
        theme = "rose_pine";
        editor = {
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          line-number = "relative";
          trim-final-newlines = true;
          trim-trailing-whitespace = true;
          true-color = true;
        };
      };
    };
  };
}
