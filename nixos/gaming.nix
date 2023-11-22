{ pkgs, inputs, ... }: {
    imports = [
        inputs.nix-gaming.nixosModules.steamCompat
        inputs.nix-gaming.nixosModules.pipewireLowLatency
    ];

    nix.settings = {
        # add github:fufexan/nix-gaming cachix
        substituters = ["https://nix-gaming.cachix.org/"];
        trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };

    # nix-gaming specific module
    services.pipewire.lowLatency.enable = true;

    programs.steam = {
        enable = true;

        # adds extra compatibility tools to your STEAM_EXTRA_COMPAT_TOOLS_PATHS
        extraCompatPackages = [
            inputs.nix-gaming.packages.${pkgs.system}.proton-ge
        ];
    };

    environment.systemPackages = [
        pkgs.gamemode
        # \/ uses legendary-gl, but I think I'd rather just use steam
        # inputs.nix-gaming.packages.${pkgs.system}.rocket-league
    ];
}
