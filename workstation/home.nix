{ pkgs, selfRepository, ... }:
let
  user = "zeta";
  homeDir = "/home/${user}";
in
{
  home.username = user;
  home.homeDirectory = homeDir;
  
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
  
  home.activation.cleanupConfigDirs = ''
    rm -rf ${homeDir}/.config/hypr
    rm -rf ${homeDir}/.config/Thunar
  '';
  
  # Let home manager manage the configuration and other files.
  home.file = {
    ".config/hypr" = { source = "${selfRepository}/config/hypr"; recursive = true;};
    ".config/Thunar" = { source = "${selfRepository}/config/Thunar"; recursive = true; };
    ".files/wallpapers" = { source = "${selfRepository}/files/wallpapers"; recursive = true; };  
  };

  home.stateVersion = "25.11";
}