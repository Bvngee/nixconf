{ inputs, pkgs, ... }: {
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swww.nix
  ];

  home.packages =
    let
      screenshot = pkgs.writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | satty \
          --filename - \
          --output-filename \
          ~/Pictures/Screenshots/$(date '+%Y-%-m-%-d_%-I-%M%P').png
      '';
      screenshotFull = pkgs.writeShellScriptBin "screenshotFull" ''
        grim -o - | satty \
          --filename - \
          --fullscreen \
          --output-filename \
          ~/Pictures/Screenshots/$(date '+%Y-%-m-%-d_%-I-%M%P').png
      '';
    in
    with pkgs; [
      grim
      slurp
      wayshot
      wl-clipboard
      wlr-randr
      wf-recorder
      wev
      libnotify
      playerctl
      satty
      inputs.woomer.packages.${system}.default
      hyprpicker

      # Preferred PolKit agent
      pkgs.pantheon.pantheon-agent-polkit
      # pkgs.libsForQt5.polkit-kde-agent

      screenshotFull
      screenshot
    ];
}
