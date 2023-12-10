{ pkgs, ... }: {
    # TODO: Add ddcutil + ddcci-driver on desktop-type systems

    environment.systemPackages = with pkgs; [
        brightnessctl
    ];
}
