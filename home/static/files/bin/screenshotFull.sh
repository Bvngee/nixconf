OUTPUT=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)' | jq -r '.name')
pidof slurp || grim -o "$OUTPUT" - | satty \
  --filename - \
  --fullscreen \
  --output-filename \
  ~/Pictures/Screenshots/"$(date '+%Y.%-m.%-d-%-I:%M%P')".png
