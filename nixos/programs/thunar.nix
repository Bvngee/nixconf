{ pkgs, ... }: {
  # System-level settings for Thunar. Further configuration is done via Home Manager

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # GUI archiver for thunar-archive-plugin. Alternative is "file-roller"
  environment.systemPackages = with pkgs; [ libsForQt5.ark ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
