{
  flake.modules.homeManager.openssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    internal.persistence = {
      home.directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };

  flake.modules.nixos.openssh = {
    lib,
    options,
    ...
  }: {
    services.openssh.enable = true;

    # Prevent the SSH server from auto-starting.
    systemd.services.sshd.wantedBy = lib.mkForce [];

    internal.persistence = {
      root.files =
        options.services.openssh.hostKeys.default
        |> lib.concatMap (key: [key.path "${key.path}.pub"])
        |> map (file: {
          inherit file;
          how = "symlink";
        });
    };
  };
}
