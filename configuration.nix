{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "beamos";
  time.timeZone = "Europe/Istanbul";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.consoleLogLevel = 3;

  users.users.beam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    initialPassword = "changeme";
  };
  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    python312
    docker
    git
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:esmacimsit/beam-os#beamos";
    dates = "hourly";
    allowReboot = false;
  };

  system.stateVersion = "24.05";
}