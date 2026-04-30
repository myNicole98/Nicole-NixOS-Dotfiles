{ config, ... }:
{
  services.displayManager.gdm = {
    enable = true;
    #autoLogin.enable = true;
    #autoLogin.user = "nicole";
  };
}
