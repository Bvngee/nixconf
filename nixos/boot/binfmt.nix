{ pkgs, pkgsUnstable, ... }: {
  environment.systemPackages = with pkgs; [
    qemu # emulate other architectures (literally magic)

    # see https://wiki.nixos.org/wiki/Wine
    wineWowPackages.stable # consider staging/wayland?
    winetricks
  ];

  # In 24.05, enabling emulatedSystems requires compiling qemu from source
  # (https://github.com/NixOS/nixpkgs/issues/221056). qemu-user is covered by
  # Hydra as of nixpkgs#314998, which will take effect when I update to 24.11.
  boot.binfmt.emulatedSystems =
    let
      # Some of these combinations may not work; most are untested.
      # TODO: should I make one giant list and automatically subtract current system's triple?
      emulationsBySystem = {
        "x86_64-linux" = [
          # Why is there no armv8-linux? Because Armv8-A introduced the 64bit
          # state (called aarch64), and the 32bit state (aarch32) retains backwards
          # compatibility with armv7/6/5/4 processors, which are all 32bit only.
          # https://askubuntu.com/questions/928227/is-armv7l-32-or-64-bit
          # https://stackoverflow.com/questions/41091934/are-armv8-and-arm64-the-same
          "aarch64-linux" # qemu
          "armv6l-linux"
          "armv7l-linux"

          "x86_64-windows" # wine
          "i686-windows" # qemu + wine

          "riscv32-linux" # qemu
          "riscv64-linux"

          "wasm32-wasi" # wasmtime
          "wasm64-wasi"
        ];
        "aarch64-linux" = [
          "x86_64-linux" # qemu
          "i386-linux"
          "i486-linux"
          "i586-linux"
          "i686-linux"

          "x86_64-windows" # qemu + wine
          "i686-windows"

          "riscv32-linux" # qemu
          "riscv64-linux"

          "wasm32-wasi" # wasmtime
          "wasm64-wasi"
        ];
      };
    in
    emulationsBySystem.${pkgs.system};


  # On most distros, people use https://github.com/multiarch/qemu-user-static or
  # https://github.com/tonistiigi/binfmt or https://github.com/dbhi/qus to setup
  # binfmt_misc registrations with their kernel. This strategy works because in
  # --privileged mode, docker containers can access the host filesystem via mounts.
  # They ship with static builds of qemu-user, mount /proc/sys/fs/binfmt_misc,
  # add registrations to it, and exit. Those binfmt_misc registrations have the F
  # flag, so the kernel allocates file descriptors for the qemu binaries
  # immediately upon registration. Now, when containers are created and the
  # kernel comes across non-native binaries inside the chroot, instead of doing a
  # path lookup for the qemu binary (which would obviously fail unless the qemu
  # binary is added to the container manually), it simply uses the already-opened
  # file descriptor for it. One caveat of this: the qemu binaries must be fully
  # static, as any dynamic library lookups will obviously fail within the
  # chroot/container. This article by the author of the binfmt_misc F flag
  # explains everything really well: https://lwn.net/Articles/679308/
  # Also see this StackOverflow answer: https://stackoverflow.com/a/72890225/11424968

  # This is a workaround for nixos-24.05: https://discourse.nixos.org/t/docker-ignoring-platform-when-run-in-nixos/21120/18?u=bvngeecord
  # TODO: when updating to nixos 24.11, this will replace everything below!
  # boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.registrations =
    let
      # I only really care about emulation in chroot-like environments when
      # building container images for Arm64 servers. For now this is good enough.
      system = "aarch64-linux";
    in
    {
      ${system} = {
        # Sets the interpreter for aarch64-linux's binfmt_misc registration to
        # be statically compiled (eg. qemu-user-static).
        interpreter = (pkgsUnstable.lib.systems.elaborate { inherit system; }).emulator pkgsUnstable.pkgsStatic;
        # Adds F flag to the binfmt_misc registration. See explanation above
        fixBinary = true;
      };
    };
}
