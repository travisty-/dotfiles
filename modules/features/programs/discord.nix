{
  # https://nixos.wiki/wiki/Discord
  flake.modules.homeManager.discord = {pkgs, ...}: {
    home.packages = with pkgs; [
      discord
    ];

    programs.vesktop = {
      enable = true;
    };

    services.arrpc = {
      enable = true;
    };
  };
}
