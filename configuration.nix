# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "braden" = import ./home.nix;
    };
  };

  # Booloader
  # boot = {
  #   kernelModules = [ "wl" ];
  #   initrd = {
  #     kernelModules = [ "nvidia" ];
  #   };
  #   kernelPackages = pkgs.linuxPackages_latest;
  #   extraModulePackages = with config.boot.kernelPackages; [
  #       nvidia_x11
  #       broadcom_sta
  #   ];
  # };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # XDG Portals
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  # Security
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  # Hardware
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      # setLdLibraryPath = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;
    };
  };

  # Services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      videoDrivers = [ "nvidia" ];
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    libinput.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      # packageOverrides = pkgs: {
      # 	unstable = import unstableTarball {
      #     config = config.nixpkgs.config;
      #   };
      # };
    };
  };

  environment.sessionVariables = {
    POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ]; # set of kernel modules loaded in second stage of boot process
  boot.initrd.kernelModules = [ "wl" ]; # list of modules always loaded by the initrd

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   jack.enable = true;

  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.braden = {
    isNormalUser = true;
    description = "Braden Steffaniak";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      signal-desktop
      telegram-desktop
      discord
    ];
  };

  fonts = {
    packages = with pkgs; [
      font-awesome
      fira-code
      fira-code-symbols
      fira-code-nerdfont
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    microsoft-edge
    kitty
    polkit_gnome
    libva-utils
    fuseiso
    udiskie
    adwaita-icon-theme
    gnome-themes-extra
    nvidia-vaapi-driver
    gsettings-desktop-schemas
    swaynotificationcenter
    wlr-randr
    ydotool
    wl-clipboard
    hyprland-protocols
    hyprpicker
    swayidle
    swaylock
    xdg-desktop-portal-hyprland
    hyprpaper
    fuzzel
    wofi
    swww
    grim
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6
    nwg-displays
    git
    rustup
    neovim
    nodejs_22
    pnpm
    go
    python3
    nix-search
    unzip
    tmux
    lazygit
    htop
    fzf
    ripgrep
    nemo
    gnome-tweaks
    steam
    xclip
    lshw
    pciutils
    usbutils
    slurm-nm
    killall
    networkmanager
    networkmanagerapplet
    wirelesstools
    eslint_d
    prettierd
    nixfmt-rfc-style
    inputs.wezterm.packages."${pkgs.system}".default
    inputs.ra-multiplex.packages."${pkgs.system}".default
    ncdu
    appimage-run
    clang
    jq
    okular
    glib
    inputs.home-manager.packages."${pkgs.system}".default
    awscli2
    kubectl
    doctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  systemd.user.services.tmux = {
    enable = false;
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
