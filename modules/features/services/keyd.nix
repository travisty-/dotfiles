{
  flake.modules.nixos.keyd = {pkgs, ...}: {
    services.keyd = {
      enable = true;
      keyboards.hhkb = {
        ids = ["04fe:0020"];
        settings = {
          main = {
            leftalt = "layer(meta)";
            leftmeta = "layer(alt)";
            rightalt = "layer(meta)";
            rightmeta = "layer(altgr)";
            space = "lettermod(navigation, space, 150, 200)";
          };
          navigation = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [keyd];
  };
}
