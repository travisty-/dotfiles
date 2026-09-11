{inputs, ...}: {
  flake.modules.homeManager.vicinae = {...}: {
    imports = [
      inputs.vicinae.homeManagerModules.default
    ];

    programs.vicinae = {
      enable = true;

      systemd = {
        enable = true;
        autoStart = true;
        environment.USE_LAYER_SHELL = 1;
      };

      settings = {
        consider_preedit = true;
        close_on_focus_loss = true;
        pop_to_root_on_close = true;
        search_files_in_root = false;
        encrypt_sensitive_data = true;
        favicon_service = "twenty";
        tray.enabled = false;
        font.normal.size = 10.5;
        # font.normal.normal = "Maple Nerd Font";
        theme.light.name = "vicinae-light";
        theme.light.icon_theme = "default";
        theme.dark.name = "vicinae-dark";
        theme.dark.icon_theme = "default";
        launcher_window.opacity = 0.95;
        launcher_window.blur.enabled = true;
        launcher_window.dim_around = true;
        launcher_window.layer_shell.layer = "overlay";
      };
    };
  };

  flake.modules.nixos.vicinae = {
    nix.settings = {
      extra-substituters = ["https://vicinae.cachix.org"];
      extra-trusted-public-keys = ["vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="];
    };
  };
}
