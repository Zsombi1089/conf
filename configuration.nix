{ config, pkgs, ... }:

let
  unstable = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {};

  pinned = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/3e7047a69e3427faeb1621c3ef835c5d60a95788.tar.gz") {};

  prismlauncher-cracked = (builtins.getFlake "github:Diegiwg/PrismLauncher-Cracked").packages.${pkgs.system}.default;

in

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  boot.blacklistedKernelModules = [
    "dvb_usb_rtl28xxu"
    "dvb_usb_v2"
    "rtl2832"
    "rtl2832_sdr"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-376d6ff5-efc1-4324-9b83-8517debce7e5".device = "/dev/disk/by-uuid/376d6ff5-efc1-4324-9b83-8517debce7e5";

  boot.kernelModules = [ "wireguard" ];


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
    extraGroups = [ "networkmanager" "wheel" "tty" "video" "render" "crossmacro"];
    packages = with pkgs; [
      kdePackages.kate
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

  programs.vim = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = false;
    vimAlias = false;

    configure = {
      customRC = ''
        lua << EOF
        dofile("${builtins.toString ./nvim/init.lua}")
        EOF
      '';
    };
  };

  programs.bash = {
    enable = true;
    interactiveShellInit = builtins.readFile ./bashrc.sh;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [
        glfw
        libGL
        mesa
        xorg.libX11
        xorg.libXrandr
        xorg.libXinerama
        xorg.libXcursor
        xorg.libXi
      ];
    };
  };

  programs.firefox.enable = true;

  programs.kdeconnect.enable = true;

  programs.ssh.startAgent = true;

  nixpkgs.config.allowUnfree = true;

  services.crossmacro = {
    enable = true;
    users = [ "n250m131" ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    amdgpuBusId = "PCI:5:0:0";
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
    android-tools
    apio
    arduino-ide
    btop
    crossmacro
    crossmacro-daemon
    digital
    discord
    dotnet-sdk_10
    element-desktop
    fastfetch
    freetube
    gajim
    gcc
    git
    gnupg
    gparted
    htop
    jdk17
    jdk21
    kdePackages.filelight
    kdePackages.kleopatra
    keepassxc
    kiwix
    #librewolf
    mediawriter
    mullvad-browser
    openfpgaloader
    organicmaps
    prismlauncher-cracked
    proton-vpn
    proton-vpn-cli
    python3
    python313Packages.argostranslate
    python313Packages.argos-translate-files
    python314Packages.pip
    rpi-imager
    rtl-sdr
    ryzenadj
    scrcpy
    sdrangel
    sdrpp
    sherlock
    signal-desktop
    steam
    stress
    teams-for-linux
    #thunderbird
    tigervnc
    tio
    tmux
    tor-browser
    vencord
    #veracrypt
    vesktop
    vlc
    vscodium
    wget
    wireguard-tools
    xinit
    xkill
    yazi
    yosys
  ]++ (with unstable;[
    nextpnr
    python314Packages.apycula
  ])++ (with pinned;[
    librewolf
    thunderbird
  ]);
  system.stateVersion = "26.05";
}
