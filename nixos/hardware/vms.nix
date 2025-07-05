{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    virtiofsd
    # requires compiling from source (it's just an alias for an override on libguestfs)
    libguestfs-with-appliance

    # nice wine/proton wrapper using gtk4 (alternative is lutris)
    bottles
  ];

  virtualisation = {
    libvirtd.enable = true;
  };

  users.users.${config.profile.mainUser}.extraGroups = [ "docker" "libvirtd" ];
}
