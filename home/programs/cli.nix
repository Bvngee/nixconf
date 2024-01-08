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
        unzip
        zip
        jq
    ];
}
