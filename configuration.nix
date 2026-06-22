{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-376d6ff5-efc1-4324-9b83-8517debce7e5".device = "/dev/disk/by-uuid/376d6ff5-efc1-4324-9b83-8517debce7e5";
  networking.hostName = "n250m131";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Budapest";

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

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "hu";
    variant = "";
  };

  console.keyMap = "hu";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."n250m131" = {
    isNormalUser = true;
    description = "n250m131";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  programs.tmux={
    enable=true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.firefox.enable = true;

  programs.kdeconnect.enable = true;

  programs.ssh.startAgent = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


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

  environment.systemPackages = with pkgs; [
    arduino-ide
    btop
    digital
    discord
    element-desktop
    fastfetch
    freetube
    gajim
    git
    gnupg
    gparted
    htop
    keepassxc
    kdePackages.filelight
    kdePackages.kleopatra
    librewolf
    mediawriter
    mullvad-browser
    proton-vpn
    rpi-imager
    ryzenadj
    sdrangel
    steam
    teams-for-linux
    thunderbird
    tigervnc
    tio
    tmux
    tor-browser
    vencord
    veracrypt
    vim
    vscodium
    wget
  ];
  system.stateVersion = "26.05";

}

