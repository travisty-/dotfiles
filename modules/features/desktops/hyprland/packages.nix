{
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    config = {
      home.packages = with pkgs; [
        brightnessctl
        hyprpicker
        hyprshot
        hyprsysteminfo
      ];
    };
  };
}
