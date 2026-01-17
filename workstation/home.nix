{ pkgs, userData, agenix, ... }:
let
  user = "zeta";
  homeDir = "/home/${user}";
  filesDir = "${homeDir}/.files";
  privSecretsDir = "${homeDir}/.secrets";
  pubSecretsDir = "${filesDir}/secrets";
  wallpaperDir = "${filesDir}/wallpapers";
  scriptDir = "${filesDir}/scripts";
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

  # Add our scripts to the paths location.
  home.sessionVariables = {
    PATH = "${scriptDir}:${builtins.getEnv "PATH"}";
  }
  
  # Clean the folders upon new install.
  # - Clean configuration folders
  # - Clean folders relating to font rendering (BraveSoftware and fontconfig)
  home.activation.cleanupConfigDirs = ''
    rm -rf ${homeDir}/.config/hypr
    rm -rf ${homeDir}/.config/Thunar

    rm -rf ${homeDir}/.cache/BraveSoftware
    rm -rf ${homeDir}/.cache/fontconfig

    rm -rf ${homeDir}/.files/wallpapers
  '';
  
  # Let home manager manage the configuration and other files.
  home.file = {
    ".config/hypr" = { source = "${userData}/config/hypr"; recursive = true; };
    ".config/mako" = { source = "${userData}/config/mako"; recursive = true;};
    ".config/Thunar" = { source = "${userData}/config/Thunar"; recursive = true; };
    
    ".files/scripts" = { source = "${userData}/files/scripts"; recursive = true; };  
    ".files/secrets" = { source = "${userData}/files/secrets"; recursive = true; };  
    ".files/wallpapers" = { source = "${userData}/files/wallpapers"; recursive = true; };  
  };
  
  # Decrypt our tarballs.
  # We need to reference age and tar from the packages as our PATH is unset during nixos-rebuild.
  home.activation.unpackTarballs = ''
    if [ -f "${pubSecretsDir}/homelab-workstation-wallpapers.age-pub" ] \
       && [ -f "${wallpaperDir}/wallpapers.tar.gz.age" ]; then

      ${pkgs.age}/bin/age -d \
        -i ${privSecretsDir}/homelab_workstation_wallpapers.age-priv \
        -o ${wallpaperDir}/wallpapers.tar.gz \
        ${wallpaperDir}/wallpapers.tar.gz.age

      ${pkgs.gnutar}/bin/tar \
        --use-compress-program=${pkgs.gzip}/bin/gzip \
        -xvf ${wallpaperDir}/wallpapers.tar.gz \
        -C ${wallpaperDir}

      rm ${wallpaperDir}/wallpapers.tar.gz
    else
      echo "Missing tarball or the secret to unpack wallpaper archive."
    fi
  '';


  home.stateVersion = "25.11";
}