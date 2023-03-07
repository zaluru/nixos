{ lib, username, hostname, pkgs, inputs, ... }:

{
  imports =
    [ (import ./plymouth.nix) ] ++
    [ (import ./bootloader.nix) ] ++
    [ (import ./fileSystem.nix) ] ++
    [ (import ./xserver.nix) ] ++
    [ (import ./../../modules/packages/python.nix ) ] ++
    [ (import ./hardware.nix) ];

  # basic configuration
  time.timeZone = "Europe/Warsaw";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  i18n.defaultLocale = "en_US.UTF-8";
  sound.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "22.11";


  # networking
  networking.hostName = "aurora";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;


  # programs
  programs.dconf.enable = true;


  # security
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = ["zaluru"];
    keepEnv = true;
    persist = true;
  }];



  # services
  services.getty.autologinUser = "zaluru";
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;



  # nix setting
  nix.settings.allowed-users = ["zaluru"];
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";
  # users
  users.users.zaluru.isNormalUser = true;
  users.users.zaluru.description = "zaluru";
  users.users.zaluru.initialPassword = "zaq12wsx";
  users.users.zaluru.extraGroups = [ "networkmanager" "wheel" ];
  users.users.zaluru.shell = pkgs.zsh;
  security.pam.services.swaylock = { };
  environment.systemPackages = with pkgs; [
    git
  ];
}
