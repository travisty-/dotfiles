{
  flake.modules.homeManager.vim = {pkgs, ...}: {
    programs.vim = {
      enable = true;
      packageConfigurable = pkgs.vim;
      extraConfig = ''
        set directory=$XDG_STATE_HOME/vim/swap//
        set backupdir=$XDG_STATE_HOME/vim/backup//
        set viminfofile=$XDG_STATE_HOME/vim/viminfo
      '';
    };

    xdg.stateFile = {
      "vim/swap/.keep".text = "";
      "vim/backup/.keep".text = "";
    };
  };
}
