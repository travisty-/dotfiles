{inputs, ...}: {
  flake.modules.homeManager.claude-desktop = {pkgs, ...}: let
    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}) claude-desktop;
  in {
    assertions = [
      {
        # https://github.com/NixOS/nixpkgs/pull/537215
        assertion = !(pkgs ? claude-desktop);
        message = "claude-desktop is now in nixpkgs!";
      }
    ];

    home.packages = [
      (claude-desktop.override {
        commandLineArgs = "--password-store=gnome-libsecret";
      })
    ];

    internal.persistence = {
      home.directories = [
        ".config/Claude"
      ];
    };
  };

  flake.modules.nixos.claude-desktop = {
    nix.settings = {
      extra-substituters = ["https://cache.numtide.com?priority=41"];
      extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
    };
  };
}
