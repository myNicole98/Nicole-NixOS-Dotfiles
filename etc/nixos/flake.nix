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
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    millennium.url = "github:SteamClientHomebrew/Millennium/next?dir=packages/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
    artcraft.url = "github:Hy4ri/artcraft-flake";

    # --- moved over from the home-manager flake ---
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dux-shell = {
      url = "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitor.url = "github:antonjah/nix-monitor";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, niri, musnix,
              affinity-nix, millennium, spicetify-nix, opencode, helium,
              artcraft, home-manager, dux-shell, nix-monitor, ... } @inputs:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit system inputs pkgs-unstable; };
      modules = [
        {
          nixpkgs.hostPlatform = system;
          nixpkgs.overlays = [
            millennium.overlays.default
            artcraft.overlays.default
            affinity-nix.overlays.default
            helium.overlays.default
            (final: prev: {
              unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
            })
          ];
        }
        niri.nixosModules.niri
        nix-flatpak.nixosModules.nix-flatpak
        musnix.nixosModules.musnix
        spicetify-nix.nixosModules.spicetify
        home-manager.nixosModules.home-manager

        ./configuration.nix

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs pkgs-unstable; };
            users.nicole = {
              imports = [
                dux-shell.homeModules.dank-material-shell
                nix-monitor.homeManagerModules.default
                ./home-manager/home.nix
                {
                  programs.nix-monitor = {
                    enable = true;
                    rebuildCommand = [ "bash" "-c" "sudo nixos-rebuild switch" ];
                    generationsCommand = [ "sh" "-c" "nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l" ];
                  };
                }
              ];
            };
          };
        }
      ];
    };
  };
}
