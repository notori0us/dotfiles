#!/usr/bin/env bash
# Link tracked dotfiles into $HOME, one symlink per file.
#
#   ./setup.sh           install/repair links (idempotent; conflicts backed up)
#   ./setup.sh --check   report drift only; exit 1 if anything needs attention
#   ./setup.sh --no-mise skip the mise bootstrap
#
# Portable: Linux + macOS, bash 3.2+. See AGENTS.md for the migration runbook.
set -euo pipefail

REPO=$(cd "$(dirname "$0")" && pwd -P)
MODE=install
BOOTSTRAP_MISE=1
for arg in "$@"; do
    case "$arg" in
        --check) MODE=check ;;
        --no-mise) BOOTSTRAP_MISE=0 ;;
        -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
        *) echo "unknown argument: $arg" >&2; exit 2 ;;
    esac
done

BACKUP="$HOME/backup/dotfiles-$(date +%Y%m%d-%H%M%S)"
DRIFT=0

say()   { printf '%-8s %s\n' "$1" "$2"; }
drift() { DRIFT=1; say "$1" "$2"; }
tilde() { printf '%s' "~${1#"$HOME"}"; }

# Canonical path of an existing file (realpath is missing on older macOS).
resolve() {
    if command -v realpath >/dev/null 2>&1; then
        realpath "$1"
    else
        perl -MCwd -e 'print Cwd::realpath($ARGV[0])' "$1"
    fi
}

backup() {  # move $HOME/<rel> aside, preserving its relative path
    mkdir -p "$BACKUP/$(dirname "$1")"
    mv "$HOME/$1" "$BACKUP/$1"
    say backup "~/$1 -> $(tilde "$BACKUP")/$1"
}

# Home-bound files: tracked paths starting with "." minus repo plumbing.
managed_files() {
    git -C "$REPO" ls-files | while IFS= read -r rel; do
        case "$rel" in
            .gitignore|.shellcheckrc|.github/*) ;;
            .*) printf '%s\n' "$rel" ;;
        esac
    done
}

# Older setups linked whole directories (~/.vim, ~/.config/<x>) into the repo.
# Replace those with real directories so per-file links (and anything else a
# tool writes there) never land inside the repo.
unfold_parents() {
    local parent dir="" part
    parent=$(dirname "$1")
    [ "$parent" = "." ] && return 0
    while [ -n "$parent" ]; do
        part=${parent%%/*}
        if [ "$part" = "$parent" ]; then parent=""; else parent=${parent#*/}; fi
        dir="${dir:+$dir/}$part"
        [ -L "$HOME/$dir" ] || continue
        case "$(resolve "$HOME/$dir" 2>/dev/null || true)" in
            "$REPO"|"$REPO"/*)
                if [ "$MODE" = check ]; then
                    drift dirlink "~/$dir is a legacy directory link into the repo"
                else
                    rm "$HOME/$dir"
                    mkdir -p "$HOME/$dir"
                    say unfold "~/$dir (was a directory link into the repo)"
                fi
                return 0 ;;
        esac
    done
}

link_one() {
    local rel=$1 src="$REPO/$1" dst="$HOME/$1"
    unfold_parents "$rel"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return 0
    fi
    if [ "$MODE" = check ]; then
        if [ -e "$dst" ] && [ "$(resolve "$dst")" = "$(resolve "$src")" ]; then
            return 0  # reachable through a legacy dir link, reported above
        elif [ -L "$dst" ]; then
            drift wrong "~/$rel -> $(readlink "$dst")"
        elif [ -e "$dst" ]; then
            if cmp -s "$dst" "$src"; then
                drift copy "~/$rel is a plain copy (same content), not a link"
            else
                drift differs "~/$rel is a real file that differs from the repo"
            fi
        else
            drift missing "~/$rel"
        fi
        return 0
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        backup "$rel"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    say link "~/$rel"
}

# Links into the repo whose target is not a managed file (renamed/removed
# files, or leftovers from older versions of this script).
prune_orphans() {
    local links link target rel
    links=$(
        {
            find "$HOME" -maxdepth 1 -type l
            [ -d "$HOME/.config" ] && find "$HOME/.config" -maxdepth 4 -type l
            [ -d "$HOME/.vim" ] && find "$HOME/.vim" -type l
        } 2>/dev/null || true
    )
    while IFS= read -r link; do
        [ -n "$link" ] || continue
        target=$(readlink "$link")
        case "$target" in
            "$REPO"/*) rel=${target#"$REPO"/} ;;
            *) continue ;;
        esac
        [ -d "$target" ] && continue  # legacy dir link; unfold_parents owns it
        printf '%s\n' "$MANAGED" | grep -qxF "$rel" && continue
        if [ "$MODE" = check ]; then
            drift orphan "$(tilde "$link") -> $target (not a managed file)"
        else
            rm "$link"
            say prune "$(tilde "$link") (pointed at unmanaged $rel)"
        fi
    done <<EOF
$links
EOF
}

repo_state() {
    local status counts
    git -C "$REPO" fetch -q 2>/dev/null || say warn "git fetch failed; ahead/behind may be stale"
    status=$(git -C "$REPO" status --porcelain)
    if [ -n "$status" ]; then
        drift dirty "repo has uncommitted changes:"
        printf '%s\n' "$status" | sed 's/^/         /'
    fi
    counts=$(git -C "$REPO" rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null || true)
    case "$counts" in
        "") say warn "no upstream branch configured" ;;
        "0	0") ;;
        *) drift sync "ahead/behind upstream: $counts" ;;
    esac
}

bootstrap_mise() {
    if command -v mise >/dev/null 2>&1 || [ -x "$HOME/.local/bin/mise" ]; then
        return 0
    fi
    if [ "$MODE" = check ]; then
        drift nomise "mise is not installed"
    elif command -v brew >/dev/null 2>&1; then
        echo "Installing mise via Homebrew..."
        brew install mise
    else
        echo "Installing mise via mise.run..."
        curl -fsSL https://mise.run | sh
    fi
}

MANAGED=$(managed_files)

if [ -e "$REPO/already_set_up" ]; then
    if [ "$MODE" = check ]; then
        drift legacy "old already_set_up marker present (setup.sh removes it)"
    else
        rm "$REPO/already_set_up"
        say legacy "removed old already_set_up marker"
    fi
fi

while IFS= read -r rel; do
    link_one "$rel"
done <<EOF
$MANAGED
EOF

prune_orphans
if [ "$BOOTSTRAP_MISE" = 1 ]; then bootstrap_mise; fi

if [ "$MODE" = check ]; then
    repo_state
    if [ "$DRIFT" = 0 ]; then
        echo "OK: $(printf '%s\n' "$MANAGED" | wc -l | tr -d ' ') managed files linked; repo clean and in sync."
        exit 0
    fi
    echo "Drift found. See AGENTS.md for how to reconcile."
    exit 1
fi

cat <<'NOTE'

Setup complete. Next:
  * `mise install` materializes tools from ~/.config/mise/config.toml
    (plus any project mise.toml once you cd into it and `mise trust` it).
  * Open a new shell. `./setup.sh --check` should then report OK.
NOTE
