{ ... }: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    # should make it easier for peer-to-peer connections to be established in
    # tricky nested-NAT and tough firewall scenarios 
    # https://tailscale.com/blog/how-nat-traversal-works
    # https://tailscale.com/kb/1082/firewall-ports
    openFirewall = true;
  };
}
