{lib, ...}: let
  inherit (lib) mkOption types;
  flakeOption = mkOption {
    type = types.str;
    default = "/etc/nixos";
    description = "The absolute path to the working tree of this flake.";
  };
in {
  flake.modules.homeManager.base.options.meta = {
    flake = flakeOption;

    user = {
      name = mkOption {
        type = types.str;
        example = "<First Name> <Last Name>";
        description = "The user's full name.";
      };

      email = mkOption {
        type = types.str;
        example = "user@example.com";
        description = "The user's email address.";
      };

      signingKey = mkOption {
        type = types.nullOr types.str;
        example = "ssh-ed25519 AAAA...";
        description = "The user's SSH public key to (optionally) enable commit signing.";
        default = null;
      };

      username = mkOption {
        type = types.str;
        example = "username";
        description = "The user's username (login).";
      };
    };
  };

  flake.modules.nixos.base = {pkgs, ...}: {
    options.meta = {
      flake = flakeOption;

      user = {
        description = mkOption {
          type = types.str;
          example = "<First Name> <Last Name>";
          description = "The user's full name.";
        };

        shell = mkOption {
          type = types.package;
          default = pkgs.zsh;
          example = pkgs.bash;
          description = "The user's default login shell.";
        };

        username = mkOption {
          type = types.str;
          example = "username";
          description = "The user's username (login).";
        };
      };
    };
  };
}
