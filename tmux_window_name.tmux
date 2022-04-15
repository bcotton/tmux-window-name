#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pip_list=$(python3 -m pip list 2> /dev/null)
if ! echo "$pip_list" | grep libtmux -q; then
    tmux display "ERROR: tmux-window-name - Python dependency libtmux not found (Check the README)"
    exit 0
fi

tmux set -g automatic-rename off
tmux set-hook -g 'after-select-window[8921]' "run-shell "$CURRENT_DIR/scripts/rename_session_windows.py""
tmux set-hook -g 'after-rename-window[8921]' 'if-shell "[ #{n:window_name} -gt 0 ]" "set -uw @tmux_window_name_enabled" "set -w @tmux_window_name_enabled 1; run-shell \"'"$CURRENT_DIR/scripts/rename_session_windows.py"'\""'
tmux set-hook -g 'after-new-window[8921]' 'set -w @tmux_window_name_enabled 1'
