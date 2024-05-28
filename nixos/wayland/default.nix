{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./sway.nix
  ];

  environment.sessionVariables = {
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    GDK_BACKEND = "wayland,x11";
    SLD_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    XDG_SESSION_TYPE = "wayland";

    NIXOS_OZONE_WL = "1";

    LIBSEAT_BACKEND = "logind";
  };

  programs.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true; # TODO: improve this section
    extraPortals = with pkgs; [ 
      # xdg-desktop-portal-gtk # Already added by Gnome; causes an error when added here too
    ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  # Replicates `systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service`
  # which is a temporary fix for the "No Apps available" error when apps try to use the OpenURI portal. Refs:
  # https://github.com/flatpak/xdg-desktop-portal-gtk/issues/440
  # https://github.com/NixOS/nixpkgs/issues/189851
  # https://discourse.nixos.org/t/clicked-links-in-desktop-apps-not-opening-browers/29114/27
  # https://github.com/NixOS/nixpkgs/issues/279434
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/per-user/%u/profile/bin:/run/current-system/sw/bin"
  '';
}
