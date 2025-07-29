{
  description = "My Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @inputs:

 let
 system = "x86_64-linux";
 pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; };
 pkgs = import nixpkgs {
   inherit system;
   overlays = [
     (final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${prev.system};
     })
   ];
 };

  in
  {
    # Define NixOS configuration
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit system;
        inherit inputs;
        inherit pkgs-unstable;
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
