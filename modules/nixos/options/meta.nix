{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.meta.user = {
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
