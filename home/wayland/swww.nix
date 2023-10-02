{ pkgs, ... }: let
  wallpaperScript = pkgs.writeShellScriptBin "apply_wallpaper" ''
    wallpaper=$1
    swww img \
      --transition-type wipe \
      --transition-angle 22 \
      --transition-step 100 \
      --transition-duration 3.5 \
      --transition-fps 75 \
      --transition-bezier .53,0,.37,.99 \
      $wallpaper
    ${pkgs.libnotify}/bin/notify-send \
      "Switched wallpaper to $(${pkgs.coreutils}/bin/basename $wallpaper)!" -i $wallpaper
  '';
  randomWallpaperScript = pkgs.writeShellScriptBin "apply_random_wallpaper" ''
    wallpaper_dir=$1
    wallpaper="$(find $wallpaper_dir -type f | shuf -n 1)"
    swww img \
      --transition-type wipe \
      --transition-angle 22 \
      --transition-step 100 \
      --transition-duration 3.5 \
      --transition-fps 75 \
      --transition-bezier .53,0,.37,.99 \
      $wallpaper
    ${pkgs.libnotify}/bin/notify-send \
      "Switched wallpaper to $(${pkgs.coreutils}/bin/basename $wallpaper)!" -i $wallpaper
  '';
in {

  home.packages = with pkgs; [
    swww

    wallpaperScript
    randomWallpaperScript
  ];

}
