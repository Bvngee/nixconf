{ inputs, config, pkgs, ... }:

{
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

  home = {
    username = "jack";  
    homeDirectory = "/home/jack";  
    stateVersion = "23.05"; # Please read the comments before changing this value.  
    
    packages = with pkgs; [  
      wf-recorder
      # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })  
    ];  
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  # Let Home Manager install and manage itself for standalone mode.
  programs.home-manager.enable = false; # currently installed via environment.systemPackages
}
