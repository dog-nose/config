{ pkgs, lib, username, homeDirectory, ... }: {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  home.packages = [
    pkgs.gh
    pkgs.ghq
    pkgs.jq
    pkgs.ripgrep
    pkgs.wget
    pkgs.curl
    pkgs.inetutils
  ];

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
  };

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

  xdg.configFile."zsh/init.zsh".source = ./zsh/init.zsh;

  xdg.configFile."fish" = {
    source = ./fish;
    recursive = true;
  };

  xdg.configFile."git" = {
    source = ./git;
    recursive = true;
  };

  xdg.configFile."tmux/tmux.conf".source = ./tmux/tmux.conf;
  xdg.configFile."tmux/scripts" = {
    source = ./tmux/scripts;
    recursive = true;
  };

  xdg.configFile."ghostty/config".source = ./ghostty/config;

  xdg.configFile."nix/nix.conf".source = ./nix/nix.conf;

  # zsh history を ~/.local/state/zsh/ に保存するためのディレクトリ作成
  home.activation.createZshStateDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p "${homeDirectory}/.local/state/zsh"
  '';
}
