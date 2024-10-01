{ config, pkgs, ... }:
let
  isNvidia = builtins.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  environment.systemPackages = with pkgs; [
    # not sure if I really need these?
    podman-compose
    podman-desktop

    # basically a docker/podman wrapper that simplifies making tightly-integrated linux containers
    # NOTE(https://github.com/89luca89/distrobox/issues/1229):
    # put "skip_workdir=1" in ~/.config/distrobox/distrobox.conf
    distrobox

    # lets you explore docker container layers
    dive

    # useful for things like moving images between registries and other locations or 
    # inspecting images without downloading
    skopeo # note: nix2container contains a patched version with support for a "nix:" source type
  ];

  virtualisation = {
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

  users.users.${config.profile.mainUser}.extraGroups = [ "docker" ];
}
