{ pkgsUnstable, config, lib, ... }: {

  # On 3/9/25, I ran `sudo sensors-detect` and it told me to add these kernel
  # modules. After adding them here, the `sensors` command correctly reports the
  # rest of the fan RPMs and temps that weren't reported previously.
  # I don't care about my other computers so atm this is just for my PC.
  boot.kernelModules = lib.mkIf (config.host.hostname == "pc") [ "coretemp" "nct6775" ];

  # "CoolerControl is a feature-rich cooling device control application for
  # Linux. It has a system daemon for background device management, as well as a
  # GUI to expertly customize your settings."
  # This lets me set actually reasonable fan curves for my PC's fans (incl. for
  # case, aio, gpu).
  # TODO(24.11): newer version of this should fix setting gpu fan curve (no
  # longer uses nvidia-settings!)

  # ----- TODO(24.11): replace with enable option in 24.11 -----
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/programs/coolercontrol.nix#L28 
  systemd = {
    packages = with pkgsUnstable.coolercontrol; [
      coolercontrol-liqctld
      coolercontrold
    ];
    services = {
      coolercontrol-liqctld.wantedBy = [ "multi-user.target" ];
      coolercontrold.wantedBy = [ "multi-user.target" ];
      coolercontrold.path =
        let
          nvidiaPkg = config.hardware.nvidia.package;
        in
        [
          nvidiaPkg # nvidia-smi
          nvidiaPkg.settings # nvidia-settings
        ];
    };
  };
  # ----- end todo -------------------------------------------

  #programs.coolercontrol.enable = false;
  # note: programs.coolercontrol.nvidiaSupport is set automatically

}
