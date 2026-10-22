{ config, pkgs, pkgs-unstable, lib, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib 
      zstd 
      stdenv.cc.cc 
      curl 
      openssl 
      attr 
      libssh 
      bzip2 
      libxml2 
      acl 
      libsodium 
      util-linux 
      xz 
      systemd
      cudaPackages.cudnn
      cudaPackages.libcublas
      cudaPackages.cuda_cudart
      stdenv.cc.cc.lib
      expat
      exiv2
      libepoxy
      libXv
    ];
  };
  # https://github.com/nix-community/nix-ld?tab=readme-ov-file#my-pythonnodejsrubyinterpreter-libraries-do-not-find-the-libraries-configured-by-nix-ld
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${pkgs.python3}/bin/python "$@"
    '')
  ];
}
