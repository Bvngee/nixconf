{ nixpkgs, inputs, ... }:
let
  nixpkgsConf = {
    # Not sure why this is needed at all? nixpkgs.nix does the same
    config.allowUnfree = true;
    config.allowUnfreePredicate = _: true;
  };

  mkNixosSystem = { system, imports }:
    let
      pkgs = import nixpkgs ({ inherit system; } // nixpkgsConf);
      pkgsUnstable = import inputs.nixpkgs-unstable ({ inherit system; } // nixpkgsConf);
    in
    nixpkgs.lib.nixosSystem {
      modules = imports;
      specialArgs = { inherit inputs pkgs pkgsUnstable; };
    };

  commonGraphicalNixosModules = [
    ../modules # source custom modules

    ../nixos/nix.nix
    ../nixos/nixpkgs.nix
    ../nixos/nix-ld.nix
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
    ../nixos/hardware/qmk.nix

    ../nixos/boot/systemd-boot.nix
    ../nixos/boot/kernel.nix

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
    system = "x86_64-linux";
    imports = [
      ./pc/profile.nix
      ./pc/nixos

      ../nixos/programs/gaming.nix

      ../nixos/kde.nix
      ../nixos/hardware/openrgb.nix
      ../nixos/hardware/ssd.nix
      ../nixos/hardware/virtualization.nix
    ] ++ commonGraphicalNixosModules;
  };
  "latitude" = mkNixosSystem {
    system = "x86_64-linux";
    imports = [
      ./latitude/profile.nix
      ./latitude/nixos

      ../nixos/kde.nix
      ../nixos/hardware/virtualization.nix
      ../nixos/hardware/ssd.nix
    ] ++ commonGraphicalNixosModules;
  };
  "precision" = mkNixosSystem {
    system = "x86_64-linux";
    imports = [
      ./precision/profile.nix
      ./precision/nixos

      ../nixos/kde.nix
      ../nixos/hardware/virtualization.nix
      ../nixos/hardware/ssd.nix
    ] ++ commonGraphicalNixosModules;
  };
}
