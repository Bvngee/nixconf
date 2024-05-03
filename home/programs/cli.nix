{ pkgs, ... }: {
    home.packages = with pkgs; [
        # Cli/Tui Tools and Commands
        ripgrep
        fd
        nix-prefetch-scripts
        appimage-run #nixos workaround
        file
        btop
        htop
        neofetch
        fastfetch
        pfetch-rs
        unzip
        zip
        jq
        killall
        wget
        curl
        socat
        dig
        traceroute
        lm_sensors
    ];
}
