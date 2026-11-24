{config, pkgs, pkgs-unstable, ... }:

# git ls-remote https://github.com/ggml-org/llama.cpp refs/heads/master
let
  llamaCppMaster = (pkgs-unstable.llama-cpp.override { cudaSupport = true; }).overrideAttrs (old: {
    version = "master-9a16f1db";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "ggml-org";
      repo = "llama.cpp";
      rev = "9a16f1dbe4722a93ab75a2d15e29aa71ef764c7b";
      hash = "sha256-Orymo7RVCLUTFUbnDQJM0YrFYaamOv57tjazODv3ljA=";
      #hash = pkgs-unstable.lib.fakeHash;
    };
    patches = [ ];  # nixpkgs patches may not apply to master; remove this line if you need them
  });
in

{
  services.llama-cpp = {
    enable = false;
    #package = llamaCppMaster;
    package = (pkgs-unstable.llama-cpp.override { cudaSupport = true; });

    modelsPreset = {
      "Qwen3.8-35B-A3B-Distill" = {
        # MODEL #
        hf-repo = "empero-ai/Qwen3.8-35B-A3B-Distill-GGUF";
        hf-file = "Qwen3.8-35B-A3B-Distill-Q4_0.gguf";  
        alias = "Qwen3.8 35B-A3B";
        # PARAMETERS #
        temp = "0.7";
        repeat-penalty = "1.1";
        top-k = "40";
      };
    };

    extraFlags = 
      [
        "-c"
        "131072"
        "--sleep-idle-seconds"
        "15"
        "--flash-attn"
        "on"
        "-ctk"
        "q8_0"
        "-ctv"
        "q8_0"
      ];
  };
}
