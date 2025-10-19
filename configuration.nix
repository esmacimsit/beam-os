{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "beamos";
  time.timeZone = "Europe/Istanbul";

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

  system.stateVersion = "24.05";

  system.autoUpgrade = {
    enable = true;
    flake = "github:esmacimsit/beam-os#beamos";  # senin repo+config adı
    dates = "hourly";        # "daily", "03:00", "Mon..Fri 03:00" da olur
    allowReboot = false;     # reboot gerektiren güncellemelerde manuel reboot
  };
}
