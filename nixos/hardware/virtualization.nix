{ config, pkgs, user, ... }:
let
  isNvidia = builtins.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  environment.systemPackages = with pkgs; [
    qemu
    virt-manager
    virt-viewer
    libguestfs-with-appliance
    virtiofsd

    # nice wine/proton wrapper using gtk4 (alternative is lutris)
    bottles

    # not sure if I really need these?
    podman-compose
    podman-desktop

    # basically a docker/podman wrapper that simplifies making tightly-integrated linux containers
    # NOTE(https://github.com/89luca89/distrobox/issues/1229):
    # put "skip_workdir=1" in ~/.config/distrobox/distrobox.conf
    distrobox
  ];

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
    };
    podman = {
      enable = true;
      # not sure that I want these yet... podman has some differences that might get annoying
      # if it fully replaces docker (especially since I dont have that much experience with docker yet)
      dockerCompat = false;
      dockerSocket.enable = false;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # replaces [docker/podman].enableNvidia
  hardware.nvidia-container-toolkit.enable = isNvidia;

  users.users.${user}.extraGroups = [ "libvirtd" "docker" ];
}
