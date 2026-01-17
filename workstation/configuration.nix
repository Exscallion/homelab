{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "palica";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable Hyprland
  hardware.graphics.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "tuigreet --cmd Hyprland";
      user = "zeta";
    };
  };

  services.libinput.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  users.users.zeta = {
    isNormalUser = true;
    description = "Zeta";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     # Hyprland
     waybar
     swaybg
     hyprlock
     hypridle

     # Utilities
     wl-clipboard
     wofi

     # Terminal
     kitty

     # File browsar
     xfce.thunar

     # Greeter
     tuigreet

     #Notification daemon
     libnotify
     mako

     # Misc
     nano
     git
     brave
     lm_sensors
     nvtopPackages.amd
     htop
  ];
  
  # Thunar services, thumbnails and mounts and trashbin support.
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # Aaaand now this is user specific, fix this in the future.
  systemd.services.pruneSystemGenerations = {
    description = "Keep only the latest 5 generations";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/home/zeta/.files/scripts/util/cleanup-system.sh";
    };
  };

  systemd.timers.pruneSystemGenerations = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemKeepFree=500M
    MaxRetentionSec=3day
  '';

  system.stateVersion = "25.11";
}
  