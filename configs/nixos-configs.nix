{ self, nixpkgs, inputs }:
let
  # Make a NixOS system.
  # Note: `system` comes from `nixpkgs.hostPlatform`, as set in
  # `hosts/<host>/nixos/hardware-configuration.nix`.
  mkNixosSystem = { imports }: nixpkgs.lib.nixosSystem {
    modules = [ ../modules ] ++ imports;
    specialArgs = { inherit self inputs; };
  };

  commonGraphicalNixosModules = [
    ../nixos/nix.nix
    ../nixos/nix-ld.nix
    ../nixos/envfs.nix
    ../nixos/users.nix
    ../nixos/greetd.nix
    ../nixos/desktop.nix

    ../nixos/wayland
    ../nixos/x11

    ../nixos/hardware/printing.nix
    ../nixos/hardware/backlight.nix
    ../nixos/hardware/opengl.nix
    ../nixos/hardware/usb.nix
    ../nixos/hardware/power.nix
    ../nixos/hardware/audio.nix
    ../nixos/hardware/network.nix
    ../nixos/hardware/bluetooth.nix
    ../nixos/hardware/libinput.nix
    ../nixos/hardware/filesystems.nix
    ../nixos/hardware/qmk.nix
    ../nixos/hardware/zmk.nix
    ../nixos/hardware/can.nix
    ../nixos/hardware/containerization.nix

    ../nixos/boot/systemd-boot.nix
    ../nixos/boot/kernel.nix
    ../nixos/boot/binfmt.nix

    ../nixos/programs/thunar.nix
    ../nixos/programs/xremap.nix
    ../nixos/programs/zsh.nix
    ../nixos/programs/kdeconnect.nix
    ../nixos/programs/ssh.nix
    ../nixos/programs/tailscale.nix
  ];
in
{
  "pc" = mkNixosSystem {
    imports = [
      ../hosts/pc/profile.nix
      ../hosts/pc/nixos

      ../nixos/programs/gaming.nix

      ../nixos/kde.nix
      ../nixos/hardware/openrgb.nix
      ../nixos/hardware/ssd.nix
      ../nixos/hardware/vms.nix
    ] ++ commonGraphicalNixosModules;
  };
  "latitude" = mkNixosSystem {
    imports = [
      ../hosts/latitude/profile.nix
      ../hosts/latitude

      ../nixos/kde.nix
      ../nixos/hardware/ssd.nix
    ] ++ commonGraphicalNixosModules;
  };
  "precision" = mkNixosSystem {
    imports = [
      ../hosts/precision/profile.nix
      ../hosts/precision/nixos

      ../nixos/programs/gaming.nix

      ../nixos/kde.nix
      ../nixos/hardware/vms.nix
      ../nixos/hardware/ssd.nix
    ] ++ commonGraphicalNixosModules;
  };
}
