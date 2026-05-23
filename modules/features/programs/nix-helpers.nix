{
  flake.modules.nixos.nix-helpers = {
    config,
    pkgs,
    ...
  }: {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5 --optimise";
      inherit (config.meta) flake;
    };

    environment.systemPackages = with pkgs; [
      nix-inspect
      nix-output-monitor
      nvd
    ];
  };
}
