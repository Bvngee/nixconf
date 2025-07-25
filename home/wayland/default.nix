{ pkgs, pkgsUnstable, ... }: {
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./swayidle.nix
    ./swaylock.nix
    ./sway.nix
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
    hyprpicker
    wlsunset
    woomer
    pkgsUnstable.app2unit # standalone compositors should try to always use this to launch apps

    # Preferred PolKit agent
    # (note that since these binaries are in /libexec we 
    # have to move them to /bin so they get added to PATH)
    (pkgs.runCommand "mate-polkit-bin" {} ''
      mkdir -p $out/bin
      for bin in ${mate.mate-polkit}/libexec/*; do 
        ln -s "$bin" $out/bin/$(basename "$bin")
      done
    '')
    
    # pantheon.pantheon-agent-polkit
    # libsForQt5.polkit-kde-agent
  ];
}
