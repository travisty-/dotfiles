{
  flake.modules.nixos.docker = {
    config,
    lib,
    ...
  }: {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      storageDriver = lib.mkIf (config.fileSystems."/".fsType == "btrfs") "btrfs";
    };

    # Relocate ~/.docker/config into $XDG_CONFIG_HOME.
    environment.sessionVariables.DOCKER_CONFIG = "$HOME/.config/docker";

    internal.persistence = {
      home.directories = [
        ".config/docker"
        ".local/share/docker"
      ];
      root.directories = [
        {
          directory = "/var/lib/docker";
          mode = "0710";
        }
      ];
    };
  };
}
