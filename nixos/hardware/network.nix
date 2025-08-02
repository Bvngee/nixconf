{ lib, pkgs, config, ... }: {

  networking.hostName = config.host.hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  networking.networkmanager.enable = true;
  # gives my user permission to change network settings
  users.users.${config.host.mainUser}.extraGroups = [ "networkmanager" ];

  # Sesolved will use the dns servers set in `networking.nameservers`:
  # https://github.com/NixOS/nixpkgs/blob/7105ae3957700a9646cc4b766f5815b23ed0c682/nixos/modules/system/boot/resolved.nix#L18
  # This also automatically sets `networking.resolvconf.enable` to false
  services.resolved = {
    enable = true;
    # I'm not sure if I want this. Does it make dns slower? todo: do better testing or research
    # dnsovertls = "false";
  };

  # tbh not sure if this is useful lol. "Whether to enable resolved for stage 1 networking"
  # TODO(24.11): look into this maybe?
  # boot.initrd.services.resolved.enable = true;

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = true;
  };

  # spams annoying notifications, tray menu is barely useful
  # programs.nm-applet = {
  #   enable = false;
  #   indicator = true;
  # };

  # Hardcoded NetworkManager configurations. First created manually in nmtui (or other tools),
  # then converted to nix code via https://github.com/janik-haag/nm2nix. These exist alongside
  # the imperatively created networks.
  # Config spec: https://networkmanager.dev/docs/api/latest/nm-settings-nmcli.html
  networking.networkmanager.ensureProfiles.profiles =
    let
      mkUCSCProfile = ssid: {
        wifi = {
          inherit ssid;
          mode = "infrastructure";
        };
        "802-1x" = {
          ca-cert = "${pkgs.fetchurl { 
            url = "https://its.ucsc.edu/wireless/docs/ca.crt";
            hash = "sha256-XrH90kYbm+QpqMrAROtmHcJDUF+6TIm3DWoYF14Jydc="; 
          }}";
          anonymous-identity = "anon";
          domain-suffix-match = "ucsc.edu";
          eap = "peap;";
          identity = "jnystrom@ucsc.edu";
          password-flags = 0; # Store password # TODO: this doesn't actually remember the password for you
          phase2-auth = "mschapv2";
        };
        connection = {
          id = "UCSC ${ssid} (nixconf)";
          type = "wifi";
          autoconnect = true;
        };
        wifi-security.key-mgmt = "wpa-eap";
        proxy = { };
      };
    in
    {
      "UCSC eduroam (nixconf)" = lib.mkIf (config.host.isMobile) (mkUCSCProfile "eduroam");
      "UCSC ResWiFi (nixconf)" = lib.mkIf (config.host.isMobile) (mkUCSCProfile "ResWiFi");
    };

  # Configures wpa_supplicant directly; mostly incompatible with the above networkingmanager
  # profiles (unless you make nm give up ownership of the entire wireless interface)
  # networking.wireless.networks = { };
}
