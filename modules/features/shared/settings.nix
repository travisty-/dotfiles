{
  flake.modules.nixos.base = {
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
