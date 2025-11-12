#! /usr/bin/env bash

windows=$(hyprctl clients -j | jq "[sort_by(.workspace.id) | .[]]")
windowNames=$(echo "$windows" | jq ".[] | .title" -r)
index=$(echo "$windowNames" | fuzzel --dmenu --index)
selectedWindow=$(echo "$windows" | jq ".[$index] | .address" -r)

hyprctl dispatch focuswindow "address:$selectedWindow"
