{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # emulate other architectures (literally magic)
    qemu

    # see https://wiki.nixos.org/wiki/Wine
    wineWowPackages.stable # consider staging/wayland?
    winetricks
  ];

  boot.binfmt.emulatedSystems =
    let
      # It's possible some of these combinations don't work; most are untested.
      systemToEmulations = {
        "x86_64-linux" = [
          "aarch64-linux" # qemu

          "x86_64-windows" # wine
          "i686-windows" # qemu + wine

          "riscv32-linux" # qemu
          "riscv64-linux" # qemu

          "wasm32-wasi"
          "wasm64-wasi"
        ];
        "aarch64-linux" = [
          "x86_64-linux" # qemu

          "x86_64-windows" # qemu + wine
          "i686-windows" # qemu + wine

          "riscv32-linux" # qemu
          "riscv64-linux" # qemu

          "wasm32-wasi"
          "wasm64-wasi"
        ];
      };
    in systemToEmulations.${pkgs.system};
}
