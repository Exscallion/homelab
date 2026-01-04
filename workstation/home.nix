{ config, pkgs, ... }:
{
  home.username = "zeta";
  home.homeDirectory = "/home/zeta";
  
  home.packages = with pkgs; [
    neofetch
  ];

  home.stateVersion = "25.11";
}
