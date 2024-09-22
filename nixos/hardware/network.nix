{ lib, pkgs, config, ... }: {

  networking.hostName = config.profile.hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

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
  networking.networkmanager.ensureProfiles.profiles = {
    "UCSC ResWiFi (via nixconf)" = lib.mkIf (config.profile.isMobile) {
      "802-1x" = {
        anonymous-identity = "anon";
        ca-cert = "${pkgs.fetchurl {
          url = "https://its.ucsc.edu/wireless/docs/ca.crt";
          hash = "sha256-XrH90kYbm+QpqMrAROtmHcJDUF+6TIm3DWoYF14Jydc=";
        }}";
        domain-suffix-match = "ucsc.edu";
        eap = "peap;";
        identity = "jnystrom@ucsc.edu";
        password-flags = 0;
        phase2-auth = "mschapv2";
      };
      connection = {
        id = "UCSC ResWiFi (via nixconf)";
        interface-name = "wlp2s0";
        type = "wifi";
        uuid = "22badf69-1a4b-4a7a-a819-78d218e5801f";
        autoconnect = true;
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      proxy = { };
      wifi = {
        ssid = "ResWiFi";
        mode = "infrastructure";
      };
      wifi-security = {
        key-mgmt = "wpa-eap";
      };
    };
  };

  # Configures wpa_supplicant directly; effectively incompatible with
  # the above networkingmanager profiles.
  # networking.wireless.networks = {
  #   ResWiFi =
  #     let
  #       cert = pkgs.fetchurl {
  #         url = "https://its.ucsc.edu/wireless/docs/ca.crt";
  #         hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #       };
  #     in
  #     {
  #       auth = ''
  #         eap=PEAP
  #         ca_cert="${cert}"
  #         phase2="auth=MSCHAPV2"
  #       '';
  #     };
  # };
}
