{lib, ...}: let
  inherit (lib) mkOption types;
in {
  flake.modules.homeManager.base.options.meta.user = {
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

  flake.modules.nixos.base.options.meta.user = {
    description = mkOption {
      type = types.str;
      example = "<First Name> <Last Name>";
      description = "The user's full name.";
    };

    username = mkOption {
      type = types.str;
      example = "username";
      description = "The user's username (login).";
    };
  };
}
