{ pkgs, ... }: {

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" "Hack" ]; })
    roboto
    inter
    noto-fonts
    noto-fonts-cjk
    font-awesome
    corefonts
    vistafonts
  ];

}
