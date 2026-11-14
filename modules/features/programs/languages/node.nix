{
  flake.modules.homeManager.node = {config, ...}: {
    home.sessionVariables = {
      # Keeps pnpm from creating a store inside projects on bind mounts.
      PNPM_CONFIG_STORE_DIR = "${config.xdg.dataHome}/pnpm/store";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    };
  };
}
