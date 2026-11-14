{
  flake.modules.nixos.printing = {
    services.printing.enable = true;

    internal.persistence = {
      root.directories = [
        "/var/lib/cups"
      ];
    };
  };
}
