{
  description = "My Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @inputs:

 let
 system = "x86_64-linux"; # change to whatever your system should be.
 pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; };
 pkgs = import nixpkgs {
   inherit system;
   overlays = [
     inputs.hyprpanel.overlay
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
        {nixpkgs.overlays = [inputs.hyprpanel.overlay];}
      ];
    };
    
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
