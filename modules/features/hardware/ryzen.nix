{
  # https://gist.github.com/dlqqq/876d74d030f80dc899fc58a244b72df0
  flake.modules.nixos.ryzen = {
    boot.kernelParams = [
      "amd_pstate=active"
      "intel_idle.max_cstate=0"
      "processor.max_cstate=1"
    ];
  };
}
