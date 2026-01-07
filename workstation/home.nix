{ config, pkgs, ... }:
{
  home.username = "zeta";
  home.homeDirectory = "/home/zeta";
  
  home.packages = with pkgs; [
    neofetch
    xfce.mousepad
  ];

  # IDE and text editing
  programs.lapce.enable = true;
  
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "mousepad.desktop" ];
        "text/x-nix" = [ "lapce.desktop" ];
      };
    };
  };

  home.stateVersion = "25.11";
} 