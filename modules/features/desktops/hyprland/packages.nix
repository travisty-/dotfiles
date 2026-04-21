{
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    config = {
      home.packages = with pkgs; [
        hyprpicker
        hyprshot
        hyprsysteminfo
      ];
    };
  };
}
