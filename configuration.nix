{ config, pkgs, ... }:


let
  # Rögzített librewolf verzió egy régebbi nixpkgs commit-ból
  librewolfPkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/e9a7635a57597d9754eccebdfc7045e6c8600e6b.tar.gz") {};
  librewolf-fix = librewolfPkgs.librewolf;


  prismlauncher-cracked = (builtins.getFlake "github:Diegiwg/PrismLauncher-Cracked").packages.${pkgs.system}.default;
in

{
  imports =
    [
      ./hardware-configuration.nix
    ];


  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-376d6ff5-efc1-4324-9b83-8517debce7e5".device = "/dev/disk/by-uuid/376d6ff5-efc1-4324-9b83-8517debce7e5";


  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };


  networking.hostName = "n250m131";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "all" ];
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

  programs.gnupg.agent = {
     enable = true;
    enableSSHSupport = false;
    pinentryPackage = pkgs.pinentry-qt;
  };

  programs.tmux={
    enable=true;
    extraConfig = builtins.readFile ./tmux.conf;
  };


  programs.bash = {
    enable = true;
    interactiveShellInit = builtins.readFile ./bashrc.sh;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
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
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    # Az NVIDIA beállítások menüjének engedélyezése
    nvidiaSettings = true;
    # A stabil illesztőprogram-csomag használata
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

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



  systemd.services.ryzenadj-tctl = {
    description = "Set Ryzen Tctl temperature limit";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --tctl-temp=75";
    };
  };



  environment.systemPackages = with pkgs; [
    appimage-run
    arduino-ide
    btop
    digital
    discord
    dotnet-sdk_10
    element-desktop
    fastfetch
    freetube
    gajim
    git
    gnupg
    gparted
    htop
    jdk17
    jdk21
    kdePackages.filelight
    kdePackages.kleopatra
    keepassxc
    librewolf
    mediawriter
    mullvad-browser
    prismlauncher-cracked
    proton-vpn
    python313Packages.argostranslate
    python313Packages.argos-translate-files
    rpi-imager
    ryzenadj
    sdrangel
    sherlock
    signal-desktop
    steam
    teams-for-linux
    thunderbird
    tigervnc
    tio
    tmux
    tor-browser
    vencord
    veracrypt
    vesktop
    vim
    vlc
    vscodium
    wget
    xkill
  ];
  system.stateVersion = "26.05";

}
