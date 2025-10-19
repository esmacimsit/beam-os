{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "beamos";
  time.timeZone = "Europe/Istanbul";

  # UEFI bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.consoleLogLevel = 3;

  # >>> Disk bağlamaları (senin VM'ine göre) <<<
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";  # az önce ext4 ile böyle label verdik
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/sda1";                  # EFI bölümü
    fsType = "vfat";
  };
  swapDevices = [ ];

  users.users.beam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    initialPassword = "changeme";
  };
  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    python312 docker git
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:esmacimsit/beam-os#beamos";
    dates = "hourly";
    allowReboot = false;
  };

  system.stateVersion = "24.05";
}