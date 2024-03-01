{ pkgs, user, ... }:
let
  # https://github.com/bottlesdevs/Bottles/issues/3162
  # NOTE: still crashes on my pc when intercating with the gui, even with latest version below
  bottles-51-11-unwrapped = pkgs.bottles-unwrapped.overrideAttrs {
    version = "51.11";
    src = pkgs.fetchFromGitHub {
      owner = "bottlesdevs";
      repo = "Bottles";
      rev = "51.11";
      sha256 = "sha256-uS3xmTu+LrVFX93bYcJvYjl6179d3IjpxLKrOXn8Z8Y=";
    };
  };
  bottles-51-11 = pkgs.bottles.override {
    bottles-unwrapped = bottles-51-11-unwrapped;
  };
in
{
  environment.systemPackages = with pkgs; [
    qemu
    virt-manager
    virt-viewer
    libguestfs-with-appliance

    bottles-51-11
  ];

  virtualisation.libvirtd = {
    enable = true;
  };

  users.users.${user}.extraGroups = [ "libvirtd" ];
}
