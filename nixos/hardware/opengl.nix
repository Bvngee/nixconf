{ lib, pkgs, hostname, ... }:
let
  # TODO: make more dynamic
  intel_iGPU = hostname == "latitude";
in
{
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        libva
      ] ++ lib.optional (intel_iGPU) pkgs.intel-media-driver;

      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ] ++ lib.optional (intel_iGPU) pkgs.pkgsi686Linux.intel-media-driver;
    };
  };

}
