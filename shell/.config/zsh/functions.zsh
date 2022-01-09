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
    xclip -o | sed 's/\$/\\(/; s/\$/\\)/' | xclip -i
}

function get_xrdb() {
  xrdb -query | grep "$1" | awk '{print $2}' | tail -n1
}
