{
  # https://nixos.wiki/wiki/Firefox
  flake.modules.nixos.firefox = {
    programs.firefox = {
      enable = true;
    };
  };
}
