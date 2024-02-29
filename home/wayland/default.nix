{ pkgs, pkgsUnstable, ... }: {
  imports = [
    ./hyprland.nix
    ./swayidle.nix
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
