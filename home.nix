{ pkgs, username, homeDirectory, ... }: {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  home.packages = [
    pkgs.gh
  ];

  programs.home-manager.enable = true;
}
