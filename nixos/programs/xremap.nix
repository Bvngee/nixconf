{ inputs, ... }: {
    imports = [
        inputs.xremap-flake.nixosModules.default
    ];
    services.xremap = {
        withWlroots = true; # future- make depend on variables?
        watch = true;
        #deviceName = "GMMK";
        userName = "jack";
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
