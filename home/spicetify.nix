{ inputs, pkgs, ... }: let 
  spicetifyPkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    # spotifyPackage = pkgsUnstable.spotify;
    # spicetifyPackage = pkgsUnstable.spicetify-cli;
    theme = spicetifyPkgs.themes.default;
    enabledExtensions = with spicetifyPkgs.extensions; [
      seekSong
      hidePodcasts
      adblock
      playNext
    ];
    enabledCustomApps = with spicetifyPkgs.apps; [
      newReleases
    ];
  };
}
