{ inputs, pkgs, pkgsUnstable, ... }: let 
  spicetifyPkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  programs.spicetify = {
    enable = true;
    spotifyPackage = pkgsUnstable.spotify;
    spicetifyPackage = pkgsUnstable.spicetify-cli;
    theme = spicetifyPkgs.themes.Default;
    enabledExtensions = with spicetifyPkgs.extensions; [
      seekSong
      hidePodcasts
      adblock
      playNext
    ];
    enabledCustomApps = with spicetifyPkgs.apps; [
      localFiles
      new-releases
    ];
  };
}
