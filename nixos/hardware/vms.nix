{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    libguestfs-with-appliance
    virtiofsd

    # nice wine/proton wrapper using gtk4 (alternative is lutris)
    bottles
  ];

  virtualisation = {
    libvirtd.enable = true;
  };

  users.users.${config.profile.mainUser}.extraGroups = [ "docker" ];
}
