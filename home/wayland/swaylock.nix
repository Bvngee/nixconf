{ ... }: {
  xdg.configFile."swaylock/config".text = ''
    ignore-empty-password
    show-failed-attempts
    indicator-idle-visible
    indicator-caps-lock
    font="Inter"
    font-size=16
  '';
}
