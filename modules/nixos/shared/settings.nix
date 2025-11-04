_: {
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    substituters = ["https://vicinae.cachix.org"];
    trusted-public-keys = ["vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="];
    trusted-users = ["@wheel"];
  };
}
