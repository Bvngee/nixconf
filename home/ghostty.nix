{ config, inputs, pkgs, ... }: {
  # Note: Ghostty's cachix cache is enabled in nixos/nix.nix temporarily

  home.packages = [
    inputs.ghostty.packages.${pkgs.system}.default
  ];

  # Waiting on:
  # https://github.com/mitchellh/ghostty/issues/1307
  xdg.configFile."ghostty/config".text =
    with config.scheme.withHashtag; ''
      window-decoration = false
      font-family = "Hack Nerd Font"
      background-opacity = 0.9
      font-size = 11
      font-thicken = true
      cursor-style-blink = false
      cursor-style = block
      shell-integration-features = sudo,no-cursor
    
      foreground = ${base05}
      background = ${base00}
      selection-foreground = ${base00}
      selection-background = ${base05}
      cursor-color = ${base05}

      # normal
      palette = 0=${base00}
      palette = 1=${base08}
      palette = 2=${base0B}
      palette = 3=${base0A}
      palette = 4=${base0D}
      palette = 5=${base0E}
      palette = 6=${base0C}
      palette = 7=${base05}
      
      # bright
      palette = 8=${base03}
      palette = 9=${base08}
      palette = 10=${base0B}
      palette = 11=${base0A}
      palette = 12=${base0D}
      palette = 13=${base0E}
      palette = 14=${base0C}
      palette = 15=${base07}

      # extended base16 colors
      palette = 16=${base09} 
      palette = 17=${base0F}
      palette = 18=${base01}
      palette = 19=${base02}
      palette = 20=${base04}
      palette = 21=${base06}    
    '';
}
