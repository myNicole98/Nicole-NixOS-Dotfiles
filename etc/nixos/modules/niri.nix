{config, pkgs, pkgs-unstable, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri = {
    package = pkgs.niri-unstable;
    enable = true;
  };
}
