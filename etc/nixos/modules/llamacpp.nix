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
    enable = true;
    #package = llamaCppMaster;
    package = (pkgs-unstable.llama-cpp.override { cudaSupport = true; });

    modelsPreset = {
      "LFM2.5-24B-A2B" = {
        # MODEL #
        hf-repo = "LiquidAI/LFM2.5-24B-A2B-GGUF";
        hf-file = "LFM2.5-24B-A2B-QAD-Q4_0.gguf";  
        alias = "LFM 2.5 24B-A2B";
        # PARAMETERS #
        temp = "0.1";
        repeat-penalty = "1.05";
        top-k = "50";
      };
      "Qwen3.8-35B-A3B-Distill-GGUF" = {
        # MODEL #
        hf-repo = "empero-ai/Qwen3.8-35B-A3B-Distill-GGUF";
        hf-file = "Qwen3.8-35B-A3B-Q4_K_M.gguf";  
        alias = "Qwen3.8 35B-A3B";
        # PARAMETERS #
        temp = "0.6";
        top-k = "20";
        top-p = "0.95";
      };
      "Swift-1.5-Qwen3.8-27B-GSQ-RCO-GGUF" = {
        # MODEL #
        hf-repo = "ukisai/Swift-1.5-Qwen3.8-27B-GSQ-RCO-GGUF";
        hf-file = "Swift-1.5-Qwen3.8-27B-GSQ-RCO-IQ3_S-mtp.gguf";  
        alias = "Swift 1.5 Qwen3.8 27B GSQ-RCO";
        # PARAMETERS #
        temp = "1.0";
        top-k = "20";
        top-p = "0.95";
        min-p = "0.0";
      };
      "MiniCPM-V-4.7-35B-A3B" = {
        # MODEL #
        hf-repo = "openbmb/MiniCPM-V-4.7-35B-A3B-gguf";
        hf-file = "MiniCPM-V-4_7-35B-A3B-Q4_K_M.gguf";  
        alias = "MiniCPM-V 4.7 35B-A3B";
        # PARAMETERS #
        temp = "0.7";
        repeat-penalty = "1.03";
        top-k = "100";
        top-p = "0.95";
        min-p = "0.0";
      };
    };

    extraFlags = 
      [
        "-c"
        "131072"
        "--sleep-idle-seconds"
        "15"
        "--no-mmproj"
      ];
  };
}
