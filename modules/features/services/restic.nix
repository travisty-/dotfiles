{
  flake.modules.nixos.restic = {config, ...}: let
    inherit (config.networking) hostName;
    inherit (config.meta.user) username;
    inherit (config.users.users.${username}) home;
    mkAnchored = map (path: "${home}/${path}");
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
          ".cargo"
          ".claude/backups"
          ".claude/file-history"
          ".claude/plugins/cache"
          ".claude/shell-snapshots"
          ".config/**/*[Cc]ache*"
          ".config/**/Service Worker"
          ".config/**/blob_storage"
          ".config/Code/logs"
          ".config/Code/WebStorage"
          ".config/mozilla/firefox/*/storage/default/*/cache"
          ".config/mozilla/firefox/*/storage/private"
          ".docker"
          ".local/share/JetBrains"
          ".local/share/Steam"
          ".local/share/Trash"
          ".local/share/bottles"
          ".local/share/docker"
          ".local/share/lutris"
          ".local/share/nvim"
          ".local/share/pnpm"
          ".local/share/umu"
          ".local/share/vicinae"
          ".npm"
          ".vscode"
          "Downloads"
          "go/pkg"
        ]
        ++ [
          "*.bak"
          "*.db-shm"
          "*.db-wal"
          "*.sqlite-shm"
          "*.sqlite-wal"
          "*.swo"
          "*.swp"
          "*.tmp"
          "*~"
          ".devenv"
          ".direnv"
          ".mypy_cache"
          ".next"
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
      extraBackupArgs = ["--exclude-caches"];
      initialize = true;
      paths = [home];
      pruneOpts = [
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
  };
}
