{
  description = "My Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode.url = "github:sst/opencode";
    musnix.url = "github:musnix/musnix";
    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
    };
    millennium.url = "github:SteamClientHomebrew/Millennium/next?dir=packages/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
  };
  outputs = { self, 
              nixpkgs, 
              nixpkgs-unstable, 
              nix-flatpak, 
              niri, 
              musnix, 
              solaar, 
              affinity-nix, 
              millennium, 
              spicetify-nix, 
              opencode,
              helium,
              ... 
            } @inputs:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
        })
      ];
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit system;
        inherit inputs;
        inherit pkgs-unstable;
      };
      modules = [
        {
          nixpkgs.hostPlatform = system;
          nixpkgs.overlays = [ millennium.overlays.default];
        }
        niri.nixosModules.niri
        nix-flatpak.nixosModules.nix-flatpak
        musnix.nixosModules.musnix
        solaar.nixosModules.default
        spicetify-nix.nixosModules.spicetify
        ./configuration.nix
        
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ 
            affinity-nix.overlays.default
            helium.overlays.default
          ];
          environment.systemPackages = [ pkgs.affinity-v3 ];
        })

      ];
    };
  };
}
