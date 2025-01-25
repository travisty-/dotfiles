{
  config,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d";
    flake = "/mount/nixos";
  };

  environment.systemPackages = with pkgs; [
    nix-inspect
    nix-output-monitor
    nvd
  ];

  # environment.sessionVariables = {
  #   FLAKE = "/mount/nixos";
  # };
}
