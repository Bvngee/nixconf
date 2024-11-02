{ inputs, pkgs, ... }: {
  # Cli/Tui tools and commands
  home.packages = with pkgs; [
    ripgrep
    fd
    nix-prefetch-scripts
    nix-output-monitor # nom
    file
    btop
    htop
    neofetch fastfetch pfetch-rs
    unzip
    trash-cli
    zip
    jq
    yq # (jq but for yaml/xml/toml)
    fzf
    zf
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
    ncdu # disk utilization viewer
    # graphviz # getting weird collisions (libgvc.so) with ags :/
  ];

  imports = [
    # enables programs.nix-index with prebuilt database, and provides options below
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index.symlinkToCacheHome = true;
  # annoying and slow command-not-found behavior
  programs.nix-index.enableZshIntegration = false;
  programs.nix-index.enableBashIntegration = false;
  # I prefer this
  programs.nix-index-database.comma.enable = true;
}
