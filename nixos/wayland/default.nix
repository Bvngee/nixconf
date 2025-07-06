{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./sway.nix
    ./uwsm.nix
  ];

  programs.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };


  # NOTE: The below is not needed for Hyprland anymore, as it is solved by UWSM
  # or the HM module's `systemd.enable`. Kept here anyways for archival purposes
  # -------------------------------------------------------------------------------------------
  # Replicates `systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service`
  # which is a temporary fix for the "No Apps available" error when apps try to use the OpenURI portal. Refs:
  # https://github.com/flatpak/xdg-desktop-portal-gtk/issues/440
  # https://github.com/NixOS/nixpkgs/issues/189851
  # https://discourse.nixos.org/t/clicked-links-in-desktop-apps-not-opening-browers/29114/27
  # https://github.com/NixOS/nixpkgs/issues/279434
  #
  # systemd.user.extraConfig = ''
  #   DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/per-user/%u/profile/bin:/run/current-system/sw/bin"
  # '';
}
