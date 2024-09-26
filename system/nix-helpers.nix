{
  config,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d";
  };

  environment.systemPackages = with pkgs; [
    nix-inspect
    nix-output-monitor
    nvd
  ];

  # programs.nh.flake = "/etc/nixos";
  environment.sessionVariables = {
    FLAKE = "/etc/nixos";
  };
}
