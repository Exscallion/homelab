{ pkgs, userData, agenix, ... }:
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
    gnupg
    agenix.packages.x86_64-linux.default
    age
    vscodium
  ];

  # Program Nix module for IDE and text editing
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];
  };
  
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
  
  # Clean the folders upon new install.
  # - Clean configuration folders
  # - Clean folders relating to font rendering (BraveSoftware and fontconfig)
  home.activation.cleanupConfigDirs = ''
    rm -rf ${homeDir}/.config/hypr
    rm -rf ${homeDir}/.config/Thunar

    rm -rf ${homeDir}/.cache/BraveSoftware
    rm -rf ${homeDir}/.cache/fontconfig
  '';
  
  # Let home manager manage the configuration and other files.
  home.file = {
    ".config/hypr" = { source = "${userData}/config/hypr"; recursive = true;};
    ".config/Thunar" = { source = "${userData}/config/Thunar"; recursive = true; };
    ".files/scripts" = { source = "${userData}/files/scripts"; recursive = true; };  
    ".files/secrets" = { source = "${userData}/files/secrets"; recursive = true; };  
    ".files/wallpapers" = { source = "${userData}/files/wallpapers"; recursive = true; };  
  };

  home.stateVersion = "25.11";
}