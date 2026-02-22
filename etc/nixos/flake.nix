{
  description = "My Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #opencode.url = "github:sst/opencode";
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix.url = "github:musnix/musnix";
    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    solaar = {
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, niri, mango, musnix, nvidia-patch, solaar, ... } @inputs:

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
        mango.nixosModules.mango
        musnix.nixosModules.musnix
        {nixpkgs.overlays = [inputs.nvidia-patch.overlays.default];}
        solaar.nixosModules.default
        ./configuration.nix
      ];

    };
  };
}
