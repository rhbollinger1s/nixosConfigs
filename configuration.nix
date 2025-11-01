 { config, pkgs, ... }:

############################################################
#################### NIXOS CONFIG FILE! ####################
############################################################

# ----- [ TODO ] ------------------------------
# - Setup firewall
# - Setup starship prompt

# ----- [ IMPORTS ] ------------------------------
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# ----- [ BOOTLOADER ] ------------------------------
  # Set Bootloader to systemd boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# ----- [ KERNEL ] ------------------------------
  # Set kernel to latest release
  boot.kernelPackages = pkgs.linuxPackages_latest;

# ----- [ HOSTNAME ] ------------------------------
  # Set up hostname
  networking.hostName = "jetBlack";

# ----- [ NETWORKING AND WIFI ] ------------------------------
  # Set up network manager
  networking.networkmanager.enable = true;

# ----- [ TIME AND INTERNATIONALIZATION ] ------------------------------
  # Timezone
  time.timeZone = "America/Chicago";
  # internationalization stuff
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

# ----- [ X11 SUPPORT ] ------------------------------
  # No X11 support...
  #services.xserver.enable = true;
  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};
# ----- [ DISPLAY MANAGER ] ------------------------------
# Disable SDDM
services.displayManager.sddm.enable = false;
# Enable Ly
# services.displayManager.ly.enable = true; (LY does not work with fish shell on nixos...)
#Enable greetd
services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

# ----- [ KDE PLASMA ] ------------------------------
  # Add KDE Plasma desktop for non technical users of PC
  services.desktopManager.plasma6.enable = true;

# ----- [ HYPRLAND ] ------------------------------
  # Add Hyprland for technical users.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

# ----- [ DRIVER CONFIG ] ------------------------------4
# GPU is a GTX 1080, thus can't use Nvidia open...
  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
    nvidia.nvidiaSettings = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidia.open = false;
  };

# ----- [ XDG PORTALS ] ------------------------------
  xdg.portal.enable = true;
  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-kde];


# ----- [ SUID WRAPPERS ] ------------------------------
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

# ----- [ USER ACCOUNTS ] ------------------------------
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robert = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "robert";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
       gparted
    ];
  };
  users.users.josh = {
    isNormalUser = true;
    description = "josh";
    extraGroups = [  ];
    packages = with pkgs; [
    ];
  };

# ----- [ PROGRAMS ] ------------------------------
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #fonts
  fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
  ];

  # Installed Packages
  environment.systemPackages = with pkgs; [
    #Term
    kitty
    foot

    #Term-Apps
    fastfetch
    cmatrix
    neovim
    asciiquarium
    htop
    lolcat
    nano
    ranger
    unzip
    vim

    #GUI
    waybar
    dunst
    libnotify
    hyprpaper
    wofi
    hyprpolkitagent
    starship

    #GUI-Apps
    kdePackages.kate
    kdePackages.dolphin
    gnome-boxes
    godot
    vlc
    libreoffice
    spotify
    obs-studio
    obsidian
    vscode

    #Games
    superTuxKart
    # bsdgames

    #else
    git
    wine
    docker
    less
    pavucontrol
    #timeshift (Not needed for nixOS, but here just in case)

  ];
  # Install firefox.
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.starship.enable = true;
  # Fish Shell Config
  programs.fish = {
    enable = true;
    shellAliases = {
      ff = "fastfetch";
      cmat = "cmatrix -Bs";
    };
    shellInit = "echo 'NixOS btw'";
  };
# ----- [ AUTO UPDATES ] ------------------------------
system.autoUpgrade.enable = true;
system.autoUpgrade.allowReboot = false;

# ----- [ SERVICES ] ------------------------------
  # Cups printing
  services.printing.enable = true;
  services.fail2ban.enable = true;
  # Use pipewire, have pulseaudio as backup
  # services.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable OpenSSH
  services.openssh.enable = true;
  #ollama
  #services.ollama = {
  #enable = true;
  #acceleration = "cuda";
  #};
  #OpenWebUI for ollama
  #services.open-webui.enable = true;
# ----- [ FLAKES ] ------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# ----- [ FIREWALL ] ------------------------------
  # Still in progress...
  #networking.firewall.allowPing = true;
  #networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  #networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
