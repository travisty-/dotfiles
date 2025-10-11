{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.settings.programs.helix;
in {
  options.settings.programs.helix = {
    enable = mkEnableOption "Helix";
  };

  config = mkIf cfg.enable {
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
