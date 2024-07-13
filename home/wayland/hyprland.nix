{ config, lib, inputs, pkgs, ... }:
let
  isNvidia = builtins.elem config.profile.hostname [ "pc" ];
  nvidiaEnvVars = ''
    # NVIDIA env vars (added automatically)
    env = LIBVA_DRIVER_NAME,nvidia
    env = GBM_BACKEND,nvidia-drm # remove if problems w/ firefox
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia # remove if problems w/ zoom or discord
    env = WLR_NO_HARDWARE_CURSORS,1
  '';
  monitorConfig =
    if (config.profile.hostname == "pc") then ''
      monitor = DP-2, 2560x1440@75, 0x270, 1
      monitor = DP-1, 2560x1440@75, 2560x0, 1, transform, 1
    '' else ''
      monitor = , preferred, auto, 1
    '';
  pluginConfig =
    let
      mkEntry = entry: "plugin = " +
        (if lib.types.package.check entry then
          "${entry}/lib/lib${entry.pname}.so"
        else
          entry);
    in
    lib.concatMapStringsSep "\n" mkEntry [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
in
{
  # A small amount of Hyprland configuration generated with nix. 
  # The rest is in home/static/files/hyprland.conf (for hot-reloading purposes)
  xdg.configFile."hypr/generated-by-nix.conf".text = ''
    # plugins
    ${pluginConfig}

    ${lib.optionalString (isNvidia) nvidiaEnvVars}

    # monitor = name, res@hz, pos, scale
    ${monitorConfig}
  '';

  # Note, usefull script
  # `hyprctl clients -j | jq '.[] | select(.xwayland == true) | {title: .title, class: .class}'`

}
