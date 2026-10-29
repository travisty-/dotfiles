{
  flake.modules.nixos.element-iii = let
    element-iii = "alsa_output.usb-JDS_Labs_JDS_Labs_Element_III-00.analog-stereo";
  in {
    services.pipewire.wireplumber.extraConfig.devices."monitor.alsa.rules" = [
      {
        matches = [{"node.name" = element-iii;}];
        actions.update-props."node.description" = "JDS Labs Element III";
      }
    ];

    # https://gitlab.freedesktop.org/pipewire/wireplumber/-/work_items/920
    services.pipewire.wireplumber.extraConfig.switch-to-element-iii = {
      "wireplumber.components" = [
        {
          arguments."node.name" = element-iii;
          name = "switch-to-element-iii.lua";
          provides = "custom.switch-to-element-iii";
          type = "script/lua";
        }
      ];
      "wireplumber.profiles".main."custom.switch-to-element-iii" = "required";
    };

    services.pipewire.wireplumber.extraScripts."switch-to-element-iii.lua" =
      builtins.readFile ./scripts/switch-to-element-iii.lua;
  };
}
