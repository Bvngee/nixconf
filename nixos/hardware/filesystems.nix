{ pkgs, ... }: {
  # TODO: experiment with more fancy filesystems? Maybe disk encryption?
  # Gool 'ol ext4 has never done me wrong but maybe I should branch out a bit

  environment.systemPackages = with pkgs; [
    ntfs3g # FUSE-based NTFS driver. Needed for gparted to manage Windows partitions

    exfatprogs # exFAT filesystem userspace utilities
  ];
}
