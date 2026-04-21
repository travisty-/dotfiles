{
  flake.modules.homeManager.swaync = {pkgs, ...}: {
    services.swaync = {
      enable = true;
    };

    home.packages = with pkgs; [
      libnotify
    ];
  };
}
