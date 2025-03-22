{ lib, pkgs, config, ... }: {

  networking.hostName = config.profile.hostname;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];

  networking.networkmanager.enable = true;
  users.users.${config.profile.mainUser}.extraGroups = [ "networkmanager" ];

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
          password-flags = 0; # Store password
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
      "UCSC eduroam (nixconf)" = lib.mkIf (config.profile.isMobile) (mkUCSCProfile "eduroam");
      "UCSC ResWiFi (nixconf)" = lib.mkIf (config.profile.isMobile) (mkUCSCProfile "ResWiFi");
    };

  # Configures wpa_supplicant directly; mostly incompatible with the above networkingmanager
  # profiles (unless you make nm give up ownership of the entire wireless interface)
  # networking.wireless.networks = { };
}
