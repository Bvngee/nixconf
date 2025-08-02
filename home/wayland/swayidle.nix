{ config, pkgs, ... }:
let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q

    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend # triggers before-sleep event
    fi
  '';

  screenlockScript = pkgs.writeShellScript "screenlock-script" ''
    ${pkgs.swaylock}/bin/swaylock -f -i ${config.host.wallpaper}
  '';
in
{
  # screen idle
  services.swayidle = {
    enable = true;
    extraArgs = [ "-d" ];
    events = [
      {
        event = "before-sleep"; # triggered by systemctl suspend
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock"; # triggered by loginctl lock-session
        command = screenlockScript.outPath;
      }
    ];
    timeouts = [
      { timeout = 297; command = ''${pkgs.libnotify}/bin/notify-send "Sleeping system in 3 seconds..."''; }
      { timeout = 298; command = ''${pkgs.libnotify}/bin/notify-send "Sleeping system in 2 seconds..."''; } # shits not working bruh
      { timeout = 299; command = ''${pkgs.libnotify}/bin/notify-send "Sleeping system in 1 second... "''; }
      { timeout = 300; command = ''${pkgs.playerctl}/bin/playerctl pause & ${screenlockScript.outPath}''; }

      { timeout = 600; command = suspendScript.outPath; }
    ];
  };
}
