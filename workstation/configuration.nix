{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
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
     hyprpaper
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

     # Misc
     nano
     git
     brave
     lm_sensors
     nvtopPackages.amd
     htop
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];


  system.stateVersion = "25.11";
}
