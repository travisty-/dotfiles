{
  flake.modules.nixos.bottles = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bottles
    ];

    internal.persistence = {
      home.directories = [
        ".local/share/bottles"
      ];
    };
  };
}
