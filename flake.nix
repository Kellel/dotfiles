{
  description = "Kellen's Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";

    # Keep Home Manager using the same stable nixpkgs for predictable module semantics.
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
  let
    system = "x86_64-linux";
    stable = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    unstablePkgs = import unstable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };
  in {
    homeConfigurations.kellen = home-manager.lib.homeManagerConfiguration {
      pkgs = stable;
      modules = [ ./home.nix ];
      extraSpecialArgs = {
        unstable = unstablePkgs;
      };
    };

    formatter.${system} = stable.nixpkgs-fmt;
  };
}
