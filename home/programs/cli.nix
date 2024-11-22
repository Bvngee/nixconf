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
    neofetch
    fastfetch
    pfetch-rs
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

  programs = {
    # fancy ls
    eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [ "--group-directories-first" ];
      icons = true;
    };

    # fancy cat
    bat = {
      enable = true;
    };

    # the best navigation tool ever (replaces cd)
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ ];
    };

    # for faster nix shell workflows
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    # faster tldr client
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = false;
        };
        updates = {
          auto_update = true;
        };
      };
    };
  };


  imports = [
    # enables programs.nix-index with prebuilt database, and provides options below
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index = {
    symlinkToCacheHome = true;
    # annoying and slow command-not-found behavior
    enableZshIntegration = false;
    enableBashIntegration = false;
  };
  # I prefer this
  programs.nix-index-database.comma.enable = true;
}
