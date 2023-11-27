{ pkgs, ... }: {
    home.packages = with pkgs; [
        # Cli/Tui Tools and Commands
        ripgrep
        fd
        nix-prefetch-scripts
        file
        btop
        htop
        neofetch
    ];
}
