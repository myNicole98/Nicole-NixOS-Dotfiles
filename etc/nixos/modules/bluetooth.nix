{ config, pkgs, lib, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      Input = {
        UserspaceHID = true;
      };
      General = {
        #Experimental = true;
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = true;
      };
    };

    settings.LE = {
      MinConnectionInterval = 24;
      MaxConnectionInterval = 40;
      ConnectionLatency = 0;
      ConnectionSupervisionTimeout = 3200;
    };
  };

  services.blueman.enable = false;
  hardware.xpadneo.enable = true;

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];

    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
  };
}
