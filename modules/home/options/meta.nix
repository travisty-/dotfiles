{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.meta.user = {
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
      type = types.str;
      example = "ssh-ed25519 AAAA...";
      description = "The user's SSH public key (for commit signing).";
    };

    username = mkOption {
      type = types.str;
      example = "username";
      description = "The user's username (login).";
    };
  };
}
