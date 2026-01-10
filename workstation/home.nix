{ config, pkgs, ... }:
{
  home.username = "zeta";
  home.homeDirectory = "/home/zeta";
  
  home.packages = with pkgs; [
    neofetch
    xfce.mousepad
    krita
    swayimg
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
        "image/jpeg" = [ "swayimg.desktop" "krita.desktop" ];
        "image/png" = [ "swayimg.desktop" "krita.desktop" ];
        "image/gif" = [ "swayimg.desktop" "krita.desktop" ];
        "image/bmp" = [ "swayimg.desktop" "krita.desktop" ];
        "image/webp" = [ "swayimg.desktop" "krita.desktop" ];
      };
    };
  };

  home.stateVersion = "25.11";
}