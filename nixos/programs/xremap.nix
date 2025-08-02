{ pkgsUnstable, config, inputs, ... }: {
    imports = [
        # The xremap flake gives us the systemd service nixos module. We use the
        # xremap package from nixpkgs though to skip building from source
        inputs.xremap-flake.nixosModules.default
    ];
    services.xremap = {
        package = pkgsUnstable.xremap; # TODO(25.05)
        enable = true;

        withWlroots = true; # future- make depend on variables?
        watch = true;
        #deviceName = "GMMK";
        userName = config.host.mainUser;
        serviceMode = "system";
        config = {
            modmap = [
                {
                    name = "CapsLock Remaps";
                    remap = {
                        "CapsLock" = "Esc";
#                        "CapsLock" = {
#                            held = "LeftCtrl";
#                            alone = "Esc";
#                            alone_timout_millis = 100;
#                        };
                    };
                }
            ];
        };
    };
}
