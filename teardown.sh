#!/usr/bin/env bash
# Undo setup.sh: remove every symlink into this repo and restore the newest
# backup of each file from ~/backup/dotfiles-*/ (or the pre-2026 ~/backup/<file>).
#
#   ./teardown.sh        show what would happen
#   ./teardown.sh --yes  do it
set -euo pipefail

REPO=$(cd "$(dirname "$0")" && pwd -P)
APPLY=0
[ "${1:-}" = "--yes" ] && APPLY=1

run() { if [ "$APPLY" = 1 ]; then "$@"; else echo "would: $*"; fi; }

newest_backup() {  # newest backup copy of $HOME/<rel>, if any
    local rel=$1 d
    # shellcheck disable=SC2012  # names are timestamps we generate; ls -r sorts them
    for d in $(ls -1d "$HOME"/backup/dotfiles-* 2>/dev/null | sort -r); do
        if [ -e "$d/$rel" ] || [ -L "$d/$rel" ]; then echo "$d/$rel"; return 0; fi
    done
    if [ -e "$HOME/backup/$rel" ]; then echo "$HOME/backup/$rel"; fi
}

links=$(
    {
        find "$HOME" -maxdepth 1 -type l
        [ -d "$HOME/.config" ] && find "$HOME/.config" -maxdepth 4 -type l
        [ -d "$HOME/.vim" ] && find "$HOME/.vim" -type l
    } 2>/dev/null || true
)

while IFS= read -r link; do
    [ -n "$link" ] || continue
    case "$(readlink "$link")" in
        "$REPO"|"$REPO"/*) ;;
        *) continue ;;
    esac
    rel=${link#"$HOME"/}
    run rm "$link"
    src=$(newest_backup "$rel")
    if [ -n "$src" ]; then
        run mv "$src" "$link"
    fi
done <<EOF
$links
EOF

if [ "$APPLY" = 0 ]; then
    echo "Dry run. Re-run with --yes to apply."
fi
