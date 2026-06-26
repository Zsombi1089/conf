clear() {
    if [ -n "$TMUX" ]; then
        command clear
        tmux clear-history
    else
        command clear
    fi
}
