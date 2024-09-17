{
  config,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 30d";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];

  # programs.nh.flake = "/etc/nixos";
  environment.sessionVariables = {
    FLAKE = "/etc/nixos";
  };
}
