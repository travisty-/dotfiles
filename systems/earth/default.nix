{pkgs, ...}: {
  imports = [
    ./configuration.nix
    ../../modules/nixos
  ];

  nixpkgs.overlays = [
    (import ../../overlays/spotify.nix)
  ];

  settings = {
    desktop = {
      gnome.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
      pipewire.enable = true;
      xpadneo.enable = true;
    };

    programs = {
      _1password.enable = true;
      bottles.enable = true;
      docker.enable = true;
      heroic.enable = true;
      lutris.enable = true;
      nix-helpers.enable = true;
      spotify.enable = true;
      steam.enable = true;
    };
  };

  # https://nixos.wiki/wiki/Btrfs#Scrubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  # Install Zsh.
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
  users.defaultUserShell = pkgs.zsh;

  # Enables completion for system packages (e.g. systemd).
  environment.pathsToLink = ["/share/zsh"];

  # Enable support for Nix flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
