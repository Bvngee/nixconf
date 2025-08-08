{ fetchurl, stdenv, kernel, kmod, ... }:
let
  version = "2.0.520-REL";
in
stdenv.mkDerivation {
  pname = "ix_usb_can";
  version = "${version}-${kernel.version}";

  src = fetchurl {
    url = "https://hmsnetworks.blob.core.windows.net/nlw/docs/default-source/products/ixxat/monitored/pc-interface-cards/socketcan-linux.gz?sfvrsn=3eb48d7_91&download=true";
    hash = "sha256-3TTftOHJiGk8K2eZxGe6dol1jJdX+o6OSJD6dxW4GLY=";
  };

  unpackPhase = ''
    runHook preUnpack

    mkdir -p socketcan_drivers ix_usb_can_src
    tar -xzf $src -C socketcan_drivers
    cd socketcan_drivers
    tar -xzf ix_usb_can_${version}.tgz -C ../ix_usb_can_src
    cd ../ix_usb_can_src

    runHook postUnpack
  '';

  kernel = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MOD_DIR=kernel/drivers/net/can/usb/ixxat_usb"
    # this is not actually used, as we override installPhase
    "DEST_DIR=$(out)/lib/modules/${kernel.modDirVersion}/$(MOD_DIR)"
  ];

  # prevent default `make install`, which calls `depmod -a` (errored in my testing)
  installPhase = ''
    runHook preInstall

    MOD_DIR=kernel/drivers/net/can/usb/ixxat_usb
    DEST_DIR=$out/lib/modules/${kernel.modDirVersion}/$MOD_DIR
    install -D $MOD_DIR/ix_usb_can.ko $DEST_DIR/ix_usb_can.ko

    runHook postInstall
  '';

  meta = {
    description = "SocketCAN Driver for Linux";
    homepage = "https://www.hms-networks.com/support/general-downloads";
  };
}
