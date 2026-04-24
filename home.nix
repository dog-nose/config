{ pkgs, username, homeDirectory, ... }: {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  home.packages = [
    pkgs.gh
  ];

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
