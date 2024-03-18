{ lib, config, inputs, pkgs, hostname, isMobile, ... }:
let
  isNvidia = builtins.elem hostname [ "pc" ];
  nvidiaEnvVars = ''
    # NVIDIA env vars (added automatically)
    env = LIBVA_DRIVER_NAME,nvidia
    env = GBM_BACKEND,nvidia-drm # remove if problems w/ firefox
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia # remove if problems w/ zoom or discord
    env = WLR_NO_HARDWARE_CURSORS,1
  '';
  monitorConfig =
    if (hostname == "pc") then ''
      monitor = DP-2, 2560x1440@75, 0x300, 1
      monitor = DP-1, 2560x1440@75, 2560x0, 1, transform, 1
    '' else ''
      monitor = , preferred, auto, 1
    '';
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    grim -g "$(slurp)" - | satty \
      --filename - \
      --output-filename \
      ~/Pictures/Screenshots/$(date '+%m%d%Y-%H:%M:%S').png
  '';
  screenshotFull = pkgs.writeShellScriptBin "screenshotFull" ''
    grim -o - | satty \
      --filename - \
      --fullscreen \
      --output-filename \
      ~/Pictures/Screenshots/$(date '+%m%d%Y-%H:%M:%S').png
  '';
in
{
  # Overrides package with hyprland flake package
  imports = [ inputs.hyprland.homeManagerModules.default ];

  # NOTE: this module adds a Hyprland package to $PATH, but it should not be used.
  # the actual Hyprland package is set and used via nixos module, NOT this HM module.
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = ''
      ${lib.optionalString (isNvidia) nvidiaEnvVars}

      # monitor = name, res@hz, pos, scale
      ${monitorConfig}
      
      exec-once = hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}
      exec-once = thunar --daemon # faster opening
      exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      #exec-once = wl-paste --watch cliphist store # add all CLIPBOARD copies in the cliphist store
      exec-once = wl-paste -p --watch wl-copy -p "" # keep PRIMARY buffer empty (functionally removes middle-click-paste)
      exec-once = sleep 0.3 && swww init # wallpaper daemon (add sleep to fix supposed race condition with Hyprland - TODO: improve?)
      
      input {
          kb_layout = us,us
          kb_variant = ,intl
          kb_options = grp:alts_toggle
          kb_model =
          kb_rules =
      
          repeat_rate = 25
          repeat_delay = 300
      
          follow_mouse = 1
          mouse_refocus = false
      
          touchpad {
              disable_while_typing = false
              #scroll_factor = 0.5
          }
      
          # -1.0 - 1.0, 0 means no modification.
          ${if isMobile then "sensitivity = -0.15" else "sensitivity = -0.75"}
      
          numlock_by_default = true
      }

      gestures {
          workspace_swipe = true
          #workspace_swipe_forever = true
          #workspace_swipe_min_speed_to_force = 0
          #workspace_swipe_use_r = true
      }
      
      general {
          gaps_in = 5
          gaps_out = 10
          border_size = 0 # 2
          # col.active_border = rgba(7daea3ff) rgba(00000000) rgba(d3869bff) 35deg
          # col.inactive_border = rgba(00000000)
      
          layout = dwindle
      }
      
      binds {
          focus_preferred_method = 1
      }
      
      misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          enable_swallow = true
          vrr = 1
          focus_on_activate = true
          mouse_move_focuses_monitor = true
          #swallow_regex = ^(kitty)$ #not working?
          #swallow_regex = ^(wezterm)$ #not working?
      }
      
      decoration {
          blur {
              enabled = true
              size = 5
              passes = 2
              new_optimizations = true
          }
          rounding = 7
      
          # dim_inactive = true
          # dim_strength = 0.1
      
          drop_shadow = true
          shadow_range = 6
          shadow_render_power = 2
          shadow_offset = 0 0
          col.shadow = rgba(00000059)
      }
      
      animations {
          enabled = true
      
          # quickened animations:
          animation = workspaces, 1, 8, default
          animation = windows, 1, 5, default
      
          # remove opacity fadein/out
          animation = fadeIn, 0, 5, default
          #animation = fadeOut, 0, 5, default
      
          # remove initial border animation
          animation = borderangle, 0, 10, default
      
      }
      
      dwindle {
          pseudotile = true
          preserve_split = true # you probably want this
      }
      
      master {
          new_is_master = true
      }

      xwayland {
        force_zero_scaling = true
        use_nearest_neighbor = true
      }
      
      plugin {
          split-monitor-workspaces {
              count = 10
          }
      }
      
      # Change fullscreen/pinned border color # I wanna use rgba(d3869bff) too...
      windowrulev2 = bordercolor rgba(ea6962ff), fullscreen:1
      windowrulev2 = bordercolor rgba(ea6962ff), pinned:1
      
      # Floating and centered dialogs
      windowrulev2 = float, class:^(xdg-desktop-portal)(.*)$
      windowrulev2 = float, title:^(Open Folder)$
      windowrulev2 = float, class:^(org.kde.polkit-kde-authentication-agent-1)$
      windowrulev2 = float, title:^(Firefox — Sharing Indicator)$
      windowrulev2 = suppressevent fullscreen, title:^(Firefox — Sharing Indicator)$
      windowrulev2 = float, title:^(Picture-in-Picture)$
      windowrulev2 = size 500 300, title:^(Picture-in-Picture)$ # firefox PiP window
      windowrulev2 = float, title:^(Open File)(.*)$
      windowrulev2 = float, title:^(Open Folder)(.*)$
      windowrulev2 = float, title:^(Select a File)(.*)$
      windowrulev2 = float, title:^(Save As)(.*)$
      windowrulev2 = float, title:^(Library)(.*)$
      windowrulev2 = float, title:^(.*)(Bitwarden)(.*)$
      windowrulev2 = suppressevent fullscreen,float, title:^(Extension: (Bitwarden - Free Password Manager) - — Mozilla Firefox)$
      windowrulev2 = suppressevent fullscreen,float, title:^(Extension: (Bitwarden - Free Password Manager) - Bitwarden — Mozilla Firefox)$
      windowrulev2 = float, class:^(com.gabm.satty)$
      windowrulev2 = float, class:^(org.kde.dolphin)$
      
      # idle inhibit while watching videos
      windowrulev2 = idleinhibit focus, class:^(mpv|.+exe)$
      windowrulev2 = idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$ # not sure this works?
      
      # Blur notification popups
      layerrule = blur, notifications
      layerrule = ignorealpha 0.6, notifications
      
      # Application keybinds
      bind = SUPER, Q, exec, kitty
      bind = SUPER SHIFT, Q, exec, [float; size 1000 600; move cursor -50% -50%] kitty
      bind = SUPER, E, exec, [float; size 1100 700; move cursor -50% -50%] thunar
      bind = SUPER, W, exec, firefox
  
      # Media keys
      bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0
      bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle
      bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle
      binde = , XF86MonBrightnessUp, exec, brightnessctl s 5%+
      binde = , XF86MonBrightnessDown, exec, brightnessctl s 5%-
      bind = , Print, exec, ${screenshot}/bin/screenshot
      bind = CONTROL, Print, exec, ${screenshotFull}/bin/screenshotFull
      bind = ALT, F5, exec, playerctl previous
      bind = ALT, F6, exec, playerctl next
      bind = ALT, F7, exec, playerctl play-pause
      
      # Hyprland functions
      bind = SUPER, D, killactive
      bind = SUPER, V, togglefloating,
      bind = SUPER SHIFT, P, pin,
      bind = SUPER, P, pseudo, # for dwindle layout
      bind = SUPER, X, togglesplit, # for dwindle layout
      bind = SUPER, F, fullscreen, 1
      bind = SUPER SHIFT, F, fullscreen, 0
      bind = SUPER CONTROL ALT, Backspace, exit # dangerous
      bind = SUPER, T, workspace, empty # alternate keybind to SUPER SHIFT K
      
      # Switch to workspace (using split-monitor-workspaces)
      # SUPER + [ 0-9 ]
      bind = SUPER, 1, split-workspace, 1
      bind = SUPER, 2, split-workspace, 2
      bind = SUPER, 3, split-workspace, 3
      bind = SUPER, 4, split-workspace, 4
      bind = SUPER, 5, split-workspace, 5
      bind = SUPER, 6, split-workspace, 6
      bind = SUPER, 7, split-workspace, 7
      bind = SUPER, 8, split-workspace, 8
      bind = SUPER, 9, split-workspace, 9
      bind = SUPER, 0, split-workspace, 10
      
      # Move active window to workspace (using split-monitor-workspaces) 
      # SUPER + SHIFT + [ 0-9 ]
      bind = SUPER SHIFT, 1, split-movetoworkspacesilent, 1
      bind = SUPER SHIFT, 2, split-movetoworkspacesilent, 2
      bind = SUPER SHIFT, 3, split-movetoworkspacesilent, 3
      bind = SUPER SHIFT, 4, split-movetoworkspacesilent, 4
      bind = SUPER SHIFT, 5, split-movetoworkspacesilent, 5
      bind = SUPER SHIFT, 6, split-movetoworkspacesilent, 6
      bind = SUPER SHIFT, 7, split-movetoworkspacesilent, 7
      bind = SUPER SHIFT, 8, split-movetoworkspacesilent, 8
      bind = SUPER SHIFT, 9, split-movetoworkspacesilent, 9
      bind = SUPER SHIFT, 0, split-movetoworkspacesilent, 10
      
      # Move window in direction
      # SUPER + CONTROL + [ vim keys ]
      bind = SUPER CONTROL, H, movewindow, l
      bind = SUPER CONTROL, J, movewindow, d
      bind = SUPER CONTROL, K, movewindow, u
      bind = SUPER CONTROL, L, movewindow, r
      
      # Move window focus 
      # SUPER + [ vim keys ]
      bind = SUPER, H, movefocus, l
      bind = SUPER, L, movefocus, r
      bind = SUPER, K, movefocus, u
      bind = SUPER, J, movefocus, d
      bind = SUPER, left, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d
      
      # Scroll through existing workspaces (includes first empty and previous workspace)
      # SUPER + SHIFT + [ scroll wheel / mouse buttons / vim keys ]
      bind = SUPER SHIFT, mouse_down, workspace, r+1
      bind = SUPER SHIFT, mouse_up, workspace, r-1
      bind = SUPER SHIFT, mouse:273, workspace, r+1
      bind = SUPER SHIFT, mouse:272, workspace, r-1
      bind = SUPER SHIFT, L, workspace, r+1
      bind = SUPER SHIFT, H, workspace, r-1
      bind = SUPER SHIFT, K, workspace, empty
      bind = SUPER SHIFT, J, workspace, previous
      
      # Focus monitor 
      # SUPER + CONTROL + [ scroll wheel / mouse buttons / vim keys ] 
      bind = SUPER SHIFT CONTROL, mouse_up, focusmonitor, r
      bind = SUPER SHIFT CONTROL, mouse_down, focusmonitor, l
      bind = SUPER SHIFT CONTROL, mouse:273, focusmonitor, r
      bind = SUPER SHIFT CONTROL, mouse:272, focusmonitor, l
      bind = SUPER SHIFT CONTROL, L, focusmonitor, r
      bind = SUPER SHIFT CONTROL, H, focusmonitor, l
      
      # Move/resize windows
      # SUPER + mouse buttons and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      
      
      # Disable middle-click paste - this is a shitty solution, better one at top
      #bind = , mouse:274, exec,
    '';
  };
}
