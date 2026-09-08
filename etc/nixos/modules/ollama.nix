{ config, pkgs, pkgs-unstable, ... }:
{
  # OLLAMA #
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
      NVIDIA_VISIBLE_DEVICES = "all";
      LD_LIBRARY_PATH = "${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64";
    };
  };
}
