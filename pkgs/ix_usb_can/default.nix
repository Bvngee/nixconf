{ stdenv, kernel, kmod, ... }: stdenv.mkDerivation {
  pname = "ix_usb_can";
  version = "2.0.520-REL-${kernel.version}";

  src = ./ix_usb_can_2.0.520-REL;

  kernel = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MOD_DIR=kernel/drivers/net/can/usb/ixxat_usb"
    "DEST_DIR=$(out)/lib/modules/${kernel.modDirVersion}/$(MOD_DIR)"
  ];

  installPhase = ''
    runHook preInstall
    install -D kernel/drivers/net/can/usb/ixxat_usb/ix_usb_can.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/can/usb/ixxat_usb/ix_usb_can.ko
    runHook postInstall
  '';

  meta = {
    description = "SocketCAN Driver for Linux";
    homepage = "https://www.hms-networks.com/support/general-downloads";
  };
}
