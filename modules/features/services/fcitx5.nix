{
  flake.modules.homeManager.fcitx5 = {lib, ...}: {
    xdg.configFile."fcitx5/config".text = lib.generators.toINI {} {
      "Hotkey/TriggerKeys"."0" = "Control+Alt+Shift+space";
      "Behavior/DisabledAddons"."0" = "clipboard";
    };
  };

  flake.modules.nixos.fcitx5 = {pkgs, ...}: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc-ut
          fcitx5-gtk
        ];
      };
    };
  };
}
