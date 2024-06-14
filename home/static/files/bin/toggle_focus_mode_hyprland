# NOTE: THIS DOES NOT CURRENTLY WORK!
# I need to figure out how to toggle ironbar's box-shadow margin as well as hyprland's.

# BROKEN IN v0.36.0
# https://github.com/hyprwm/Hyprland/issues/4974
focus_mode=$(hyprctl getoption -j general:gaps_in | jq '.set')
if [ "$focus_mode" = "true" ]; then
    cmd=""
    cmd+="keyword general:gaps_in 5;"
    cmd+="keyword general:gaps_out 5,10,10,10;"
    hyprctl --batch "$cmd"
else
    cmd=""
    cmd+="keyword general:gaps_in 0;"
    cmd+="keyword general:gaps_out 0;"
    hyprctl --batch "$cmd"
fi
