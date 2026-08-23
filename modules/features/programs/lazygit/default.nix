{
  flake.modules.homeManager.lazygit = {pkgs, ...}: let
    app = pkgs.writeShellApplication {
      name = "git";
      runtimeInputs = [pkgs.git];
      bashOptions = ["errexit" "pipefail"]; # nounset
      text = builtins.readFile ./scripts/git;
    };
  in {
    programs.lazygit = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "lazygit-wrapped";
        paths = [pkgs.lazygit];
        nativeBuildInputs = [pkgs.makeBinaryWrapper];
        postBuild = "wrapProgram $out/bin/lazygit --prefix PATH : ${app}/bin";
      };
    };
  };
}
