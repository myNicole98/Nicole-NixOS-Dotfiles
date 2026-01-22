{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.kawaiCA49;
in
{
  options.hardware.kawaiCA49 = {
    enable = mkEnableOption "Kawai CA49 Bluetooth MIDI support";
    
    user = mkOption {
      type = types.str;
      description = "User to run the MIDI connection service as";
    };
    
    virtualMidiDevice = mkOption {
      type = types.str;
      default = "Virtual Raw MIDI";
      description = "Virtual MIDI device name to connect to";
    };
  };

  config = mkIf cfg.enable {
    # Load virtual MIDI kernel module
    boot.kernelModules = [ "snd-virmidi" ];
    boot.extraModprobeConfig = ''
      options snd-virmidi midi_devs=1
    '';

    # Create a system service that runs as the user
    systemd.services.midi-connect-ca49 = {
      description = "Monitor and connect CA49 Piano to Virtual MIDI";
      wantedBy = [ "multi-user.target" ];
      after = [ "sound.target" "bluetooth.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Restart = "always";
        RestartSec = "5s";
        ExecStart = pkgs.writeShellScript "monitor-ca49-midi" ''
          set -euo pipefail
          
          connect_ca49() {
            # Find CA49 client number (not port number)
            CA49_CLIENT=$(${pkgs.alsa-utils}/bin/aconnect -l | grep -oP "client \K[0-9]+(?=:.*CA49)" || true)
            
            # Find Virtual MIDI client number
            VIRMIDI_CLIENT=$(${pkgs.alsa-utils}/bin/aconnect -l | grep -oP "client \K[0-9]+(?=:.*${cfg.virtualMidiDevice})" || true)
            
            if [ -z "$CA49_CLIENT" ] || [ -z "$VIRMIDI_CLIENT" ]; then
              return 0
            fi
            
            # Check if already connected
            if ${pkgs.alsa-utils}/bin/aconnect -l | grep -q "$CA49_CLIENT:0.*Connecting To:.*$VIRMIDI_CLIENT:0"; then
              return 0
            fi
            
            # Try to connect
            if ${pkgs.alsa-utils}/bin/aconnect "$CA49_CLIENT:0" "$VIRMIDI_CLIENT:0" 2>/dev/null; then
              echo "Connected CA49 (client $CA49_CLIENT) to Virtual MIDI (client $VIRMIDI_CLIENT)"
            fi
          }
          
          # Initial connection attempt
          sleep 2
          connect_ca49
          
          # Monitor for new ALSA sequencer events
          ${pkgs.alsa-utils}/bin/aseqdump -p 0:1 | while read -r line; do
            if echo "$line" | grep -q "Port subscribed\|Port start"; then
              sleep 1
              connect_ca49
            fi
          done
        '';
      };
    };
  };
}
