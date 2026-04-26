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
    solaar = {
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
    };
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, niri, mango, musnix, solaar, affinity-nix, millennium, ... } @inputs:

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
        {
          environment.systemPackages = [affinity-nix.packages.x86_64-linux.v3];
          nixpkgs.overlays = [ millennium.overlays.default ];
        }
        niri.nixosModules.niri
        nix-flatpak.nixosModules.nix-flatpak
        mango.nixosModules.mango
        musnix.nixosModules.musnix
        solaar.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
