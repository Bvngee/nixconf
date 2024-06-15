# NOTE: Only source on systems using SSDs!
{...}: {
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
