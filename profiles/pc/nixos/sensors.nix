{ config, lib, ... }: {
  
  # On 3/9/25, I ran `sudo sensors-detect` and it told me to add these kernel
  # modules. After adding them here, the `sensors` command correctly reports the
  # rest of the fan RPMs and temps that weren't reported previously.
  # I don't care about my other computers so atm this is just for my PC.
  boot.kernelModules = lib.mkIf (config.profile.hostname == "pc") [ "coretemp" "nct6775" ];

  # "CoolerControl is a feature-rich cooling device control application for
  # Linux. It has a system daemon for background device management, as well as a
  # GUI to expertly customize your settings."
  # This lets me set actually reasonable fan curves for my PC's fans (incl. for
  # case, aio, gpu).
  # TODO(24.11): newer version of this should fix setting gpu fan curve (no
  # longer uses nvidia-settings!)
  programs.coolercontrol.enable = true;
  # note: programs.coolercontrol.nvidiaSupport is set automatically

}
