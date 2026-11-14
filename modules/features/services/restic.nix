{
  flake.modules.nixos.restic = {
    config,
    lib,
    ...
  }: let
    inherit (config.networking) hostName;
    inherit (config.meta.user) username;
    inherit (config.users.users.${username}) home;
    persistent = config.preservation.enable or false;
    root = "${lib.optionalString persistent "/persist"}${home}";
    mkAnchored = map (path: "${root}/${path}");
    bucket = "restic-backups-4b1d";
    region = "us-west-004";
  in {
    sops.secrets = {
      AWS_ACCESS_KEY_ID = {};
      AWS_SECRET_ACCESS_KEY = {};
      RESTIC_PASSWORD = {};
    };

    sops.templates.restic.content = ''
      AWS_ACCESS_KEY_ID=${config.sops.placeholder.AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY=${config.sops.placeholder.AWS_SECRET_ACCESS_KEY}
    '';

    services.restic.backups.b2 = {
      environmentFile = config.sops.templates.restic.path;
      passwordFile = config.sops.secrets.RESTIC_PASSWORD.path;
      exclude =
        mkAnchored [
          ".cache"
          ".config/**/*[Cc]ache*"
          ".config/**/Service Worker"
          ".config/**/blob_storage"
          ".config/Code/logs"
          ".config/Code/WebStorage"
          ".config/claude/backups"
          ".config/claude/file-history"
          ".config/claude/plugins/cache"
          ".config/claude/shell-snapshots"
          ".config/heroic/tools"
          ".config/mozilla/firefox/*/storage"
          ".local/share/JetBrains"
          ".local/share/Steam"
          ".local/share/Trash"
          ".local/share/bottles"
          ".local/share/cargo"
          ".local/share/docker"
          ".local/share/lutris"
          ".local/share/nvim"
          ".local/share/pnpm"
          ".local/share/umu"
          ".local/share/uv"
          ".local/share/vicinae"
          ".vscode"
          "Downloads"
        ]
        ++ lib.optionals persistent [
          "/persist/etc/ssh"
          "/persist/var/lib/docker"
          "/persist/var/lib/systemd/coredump"
        ]
        ++ [
          "**/forks"
          "*.bak"
          "*.db-shm"
          "*.db-wal"
          "*.sqlite-shm"
          "*.sqlite-wal"
          "*.swo"
          "*.swp"
          "*.tmp"
          "*~"
          ".Trash-*"
          ".devenv"
          ".direnv"
          ".mypy_cache"
          ".next"
          ".pnpm-store"
          ".pytest_cache"
          ".ruff_cache"
          ".tox"
          ".venv"
          "__pycache__"
          "_build"
          "node_modules"
          "result"
          "result-*"
          "target"
        ];
      extraBackupArgs = [
        "--exclude-caches"
        "--exclude-larger-than=512M"
        "--one-file-system"
      ];
      initialize = true;
      paths =
        if persistent
        then ["/persist"]
        else [home];
      pruneOpts = [
        "--group-by host"
        "--keep-daily 14"
        "--keep-weekly 8"
        "--keep-monthly 12"
        "--keep-yearly 3"
      ];
      repository = "s3:s3.${region}.backblazeb2.com/${bucket}/${username}@${hostName}";
      runCheck = true;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };

    internal.persistence = {
      root.directories = [
        {
          directory = "/var/cache/restic-backups-b2";
          mode = "0700";
        }
      ];
    };
  };
}
