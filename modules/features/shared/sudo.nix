{
  flake.modules.nixos.base = {
    security.sudo.extraConfig = "Defaults lecture = never";
  };
}
