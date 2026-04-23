#!/bin/bash
if [[ -n "$WAYLAND_DISPLAY" ]]; then
  paste_cmd="wl-paste"
else
  paste_cmd="xclip -selection clipboard -o"
fi

content=$($paste_cmd --type text/plain 2>/dev/null || $paste_cmd)
lines=$(printf "%s" "$content" | wc -l)
chars=$(printf "%s" "$content" | wc -c)
printf "%s" "$content" | tmux load-buffer -
if [ "$lines" -gt 3 ] || [ "$chars" -gt 150 ]; then
    tmux confirm-before -p "Paste ${lines} lines, ${chars} chars? (y/n)" "paste-buffer -p"
else
    tmux paste-buffer -p
fi
exit 0
