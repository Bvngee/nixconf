{ pkgs, ... }: {
  # Cli/Tui tools and commands
  home.packages = with pkgs; [
    ripgrep
    fd
    nix-prefetch-scripts
    appimage-run #nixos workaround
    file
    btop
    htop
    neofetch fastfetch pfetch-rs
    unzip
    trash-cli
    zip
    jq
    killall
    wget
    curl
    socat
    dig
    traceroute
    nmap
    lm_sensors
    usbutils
    pciutils
    tokei
    #nvtopPackages.full # uncomment in future? throwing annoying trace warnings
    inotify-tools
    playerctl
    libnotify
    glib
    lsof
    progress
    ffmpeg
    # graphviz # getting weird collisions (libgvc.so) with ags :/
  ];
}
