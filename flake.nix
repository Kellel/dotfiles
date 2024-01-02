{
  description = "My Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    defaultPackage.x86_64-linux = inputs.home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      "kellen" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/kellen";
        username = "kellen";
        configuration.imports = [ ./home.nix ];
      };
    };
  };
}
