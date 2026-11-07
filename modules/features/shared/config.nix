{
  flake.modules.nixos.base = {config, ...}: {
    sops.secrets.GITHUB_ACCESS_TOKEN = {};

    # https://nix.dev/manual/nix/latest/command-ref/conf-file.html#conf-access-tokens
    # https://devenv.sh/getting-started/#3-configure-a-github-access-token-optional
    sops.templates.access-tokens = {
      content = "access-tokens = github.com=${config.sops.placeholder.GITHUB_ACCESS_TOKEN}";
      group = "wheel";
      mode = "0440";
    };

    nix.extraOptions = "!include ${config.sops.templates.access-tokens.path}";
  };
}
