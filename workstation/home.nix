{ pkgs, selfRepository, ... }:
{
  home.username = "zeta";
  home.homeDirectory = "/home/zeta";
  
  #Install default packages that aren't nix modules.
  home.packages = with pkgs; [
    neofetch
    xfce.mousepad
    krita
    swayimg
  ];

  # Lapce Nix module for IDE and text editing
  programs.lapce.enable = true;
  
  # Manage file associations
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
  
  # Let home manager manage the configuration and other files.
  home.file = {
    ".config/hypr" = {
      source = "${selfRepository}/config/hypr";
      recursive = true;
      force = true;
    };
    
    ".config/Thunar" = {
      source = "${selfRepository}/config/Thunar";
      recursive = true;
      force = true;
    };

    ".files/wallpapers" = {
      source = "${selfRepository}/files/wallpapers";
      recursive = true;
    };  
  };

  home.stateVersion = "25.11";
}