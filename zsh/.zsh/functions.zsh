onmodify() {
    TARGET=${1:-.}; shift
    CMD="$@"

    echo "$TARGET" "$CMD"
    while inotifywait --exclude '.git' -qq -r -e close_write,moved_to,move_self $TARGET; do
        sleep 0.2
        bash -c "$CMD"
        echo
    done
}

cmath(){
    xclip -o | sed 's/<math>/ \\(/g;  s/<\/math>/\\) /g' | xclip -i
}
