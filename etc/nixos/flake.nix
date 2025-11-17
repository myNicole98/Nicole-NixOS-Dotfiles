{
  description = "My Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-citizen.url = "github:LovingMelody/nix-citizen";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, niri, ... } @inputs:

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
        niri.nixosModules.niri
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
      ];
    };
  };
}
