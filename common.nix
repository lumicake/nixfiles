{ config, pkgs, ... }:
let 
  login = "lumi";
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  # Use the systemd-boot EFI boot loader.  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Configure X11, xfce and i3
  services.xserver = {
    enable = true;

    autoRepeatDelay = 190;
    autoRepeatInterval = 25;

    layout = "us";
    xkbVariant = "altgr-intl";
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager.defaultSession = "xfce+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        # i3status
        i3lock
      ];
    };
  };

  # Enable sound.   
  nixpkgs.config = {  
    pulseaudio = true; 
    allowUnfree = true;
  };
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${login}" = {
    createHome = true;  
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
    group = "users";
    home = "/home/" + login;
    shell = pkgs.zsh;
    initialPassword = "cats1234";
  };

  fonts.fonts = with pkgs; [
    roboto liberation_ttf dejavu_fonts

    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  home-manager.users."${login}" = import ./home/home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  virtualisation = {
    docker.enable = true;
  };
}

