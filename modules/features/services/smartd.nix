{
  flake.modules.nixos.smartd = {
    services.smartd = {
      enable = true;

      # Runs a short self-test every Monday at 10:00 AM, and a
      # long self-test the first Monday of each month at 10:00 AM.
      defaults.monitored = "-a -o on -s (S/../../1/10|L/../0[1-7]/1/10)";

      # Requires a separate notification channel (wall).
      # https://github.com/NixOS/nixpkgs/pull/569022
      notifications.systembus-notify.enable = true;
    };
  };
}
