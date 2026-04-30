{config, pkgs, pkgs-unstable, input, ... }:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri = {
    package = pkgs.niri-unstable;
    enable = true;
  };
}
