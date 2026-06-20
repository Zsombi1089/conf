# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true; boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-32eb8e29-7935-4ab5-b71b-21dd251a732f".device = "/dev/disk/by-uuid/32eb8e29-7935-4ab5-b71b-21dd251a732f"; networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary networking.proxy.default = "http://user:password@proxy:port/"; networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall altogether. networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
        LC_ADDRESS = "hu_HU.UTF-8";
        LC_IDENTIFICATION = "hu_HU.UTF-8";
        LC_MEASUREMENT = "hu_HU.UTF-8";
        LC_MONETARY = "hu_HU.UTF-8";
        LC_NAME = "hu_HU.UTF-8";
        LC_NUMERIC = "hu_HU.UTF-8";
        LC_PAPER = "hu_HU.UTF-8";
        LC_TELEPHONE = "hu_HU.UTF-8";
        LC_TIME = "hu_HU.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "hu";

  security.rtkit.enable = true;

  # Engedélyezzük a nem szabad szoftverek használatát

  # NVIDIA konfiguráció
  hardware.nvidia = {
    # A modesetting engedélyezése kötelező
    modesetting.enable = true;
    # Az NVIDIA nyílt forráskódú kernel moduljának használata (ajánlott RTX 20xx-től)
    open = true;
    # A teljesítménymenedzsment kísérleti funkció, kikapcsolva hagyom
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # Az NVIDIA beállítások menüjének engedélyezése
    nvidiaSettings = true;
    # A stabil illesztőprogram-csomag használata
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Alapvető gyorsítás engedélyezése
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia.prime = {
    # Az NVIDIA offload (kirendelés) funkciójának engedélyezése
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Az AMD GPU busz azonosítója
    amdgpuBusId = "PCI:5:0:0";
    # Az NVIDIA GPU busz azonosítója
    nvidiaBusId = "PCI:1:0:0";
  };
  # Ryzen CPU hőmérsékleti korlát 75°C-ra
  hardware.ryzen-smu.enable = true;
  services.ryzenadj = {
    enable = true;
    settings = {
      tctl-temp = 75;
    };
  };

  # Enable the X11 windowing system. You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = { layout = "hu"; variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager). services.xserver.libinput.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true; services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon. services.openssh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.kdeconnect.enable = true;

  # Tmux configuration
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions. programs.mtr.enable = true; programs.gnupg.agent = {
  #   enable = true; enableSSHSupport = true;
  # };

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
  vim
  tmux
  btop
  fastfetch
  steam
  librewolf
  wget
  git
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default. wget
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the
  # release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
