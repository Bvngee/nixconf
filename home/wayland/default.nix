{ pkgs, pkgsUnstable, ... }: {
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
    wl-clipboard
    wlr-randr
    wf-recorder
    wev
    hyprpicker
    libnotify
    pkgsUnstable.satty
    playerctl
  ];
}
