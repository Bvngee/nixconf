pidof slurp || grim -g "$(slurp)" - | satty \
    --filename - \
    --output-filename \
    ~/Pictures/Screenshots/"$(date '+%Y.%-m.%-d-%-I:%M%P')".png
