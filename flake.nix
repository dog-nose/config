{
  description = "dog-nose's personal configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
    in {
      homeConfigurations."dog-nose" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = { inherit username homeDirectory; };
        modules = [ ./home.nix ];
      };
    };
}
