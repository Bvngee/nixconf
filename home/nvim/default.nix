{ inputs, config, pkgs, ... }: {
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.host.flakeRoot}/home/nvim/config";

  home.packages = [
    # Extremely temporary; pending config rewrite!
    inputs.nixpkgs-neovim.legacyPackages.${pkgs.system}.neovim
  ];

  programs.neovim = {
    enable = false;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withRuby = false;
    withPython3 = false;
    withNodeJs = false;

    extraPackages = with pkgs; [
      stdenv.cc
      gnumake
      ripgrep
      fd
    ];
  };

  # Replace the default nvim.desktop (found at
  # ~/.nix-profile/share/applications/nvim.desktop for HM) with a copy that sets
  # Terminal=False and launches neovim with $TERMINAL instead of letting whatever
  # the launching application is choose the terminal emulator

  # TODO: THIS DOES NOT WORK WITH SYSTEMD-STARTED THUNAR
  home.file.".local/share/applications/nvim.desktop".source =
    let
      nvim = config.programs.neovim.package;
    in
    "${pkgs.runCommand "fix-nvim-desktop" {} ''
      mkdir -p $out
      cp ${"${nvim}/share/applications/nvim.desktop"} $out/nvim.desktop
      substituteInPlace $out/nvim.desktop \
        --replace-fail "Exec=nvim %F" "Exec=sh -c \"\$TERMINAL nvim %F\"" \
        --replace-fail "Terminal=true" "Terminal=false"
    ''}/nvim.desktop";
}


