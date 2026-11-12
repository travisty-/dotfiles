{
  flake.modules.nixos.base = {
    nix.channel.enable = false;
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
      trusted-users = ["@wheel"];
      use-xdg-base-directories = true;
    };
  };
}
