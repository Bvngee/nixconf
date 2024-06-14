{ inputs, pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swww.nix
  ];

  home.packages =
    with pkgs; [
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

      # Preferred PolKit agent
      pkgs.pantheon.pantheon-agent-polkit
      # pkgs.libsForQt5.polkit-kde-agent
    ];
}
