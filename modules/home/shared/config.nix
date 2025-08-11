{config, ...}: {
  sops.secrets.GITHUB_ACCESS_TOKEN = {};

  # https://nix.dev/manual/nix/latest/command-ref/conf-file.html#conf-access-tokens
  # https://devenv.sh/getting-started/#3-configure-a-github-access-token-optional
  sops.templates."nix.conf".path = "${config.xdg.configHome}/nix/nix.conf";

  sops.templates."nix.conf".content = ''
    access-tokens = github.com=${config.sops.placeholder.GITHUB_ACCESS_TOKEN}
  '';
}
