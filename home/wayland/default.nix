{ inputs, pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swww.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp
    wayshot
    wl-clipboard
    wlr-randr
    wf-recorder
    wev
    libnotify
    playerctl
    satty
    inputs.woomer.packages.${system}.default
    hyprpicker
    wlsunset

    # Preferred PolKit agent
    # (note that since these binaries are in /libexec they are
    # only accessible from /run/current-system/sw/libexec/..)
    mate.mate-polkit
    # pantheon.pantheon-agent-polkit
    # libsForQt5.polkit-kde-agent
  ];
}
