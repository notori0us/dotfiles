#!/usr/bin/env bash
set -euo pipefail

# Symlink tracked dotfiles into $HOME, backing up any conflicts to ~/backup/.
# Also handles ~/.config/<name> entries and bootstraps mise.
# Re-running after success is a no-op (gated by ./already_set_up).

cd "$(dirname "$0")"

if [ -e ./already_set_up ]; then
    echo "Already set up (./already_set_up exists). Nothing to do."
    exit 0
fi

# step a) back up + symlink top-level dotfiles
mkdir -p "$HOME/backup"

for dotfile in .*; do
    case "$dotfile" in
        .|..|.git|.gitignore|.config) continue ;;
    esac

    if [ -e "$HOME/$dotfile" ] || [ -L "$HOME/$dotfile" ]; then
        mv "$HOME/$dotfile" "$HOME/backup/$dotfile"
    fi

    # step b) symlink
    ln -s "$PWD/$dotfile" "$HOME/$dotfile"
done

# step c) symlink ~/.config/<name> entries from this repo
if [ -d ./.config ]; then
    mkdir -p "$HOME/.config"
    for cfg_path in ./.config/*; do
        [ -e "$cfg_path" ] || continue
        cfg_name=$(basename "$cfg_path")

        if [ -e "$HOME/.config/$cfg_name" ] || [ -L "$HOME/.config/$cfg_name" ]; then
            mv "$HOME/.config/$cfg_name" "$HOME/backup/.config_$cfg_name"
        fi
        ln -s "$PWD/.config/$cfg_name" "$HOME/.config/$cfg_name"
    done
fi

# step d) bootstrap mise (no-op if already installed)
if ! command -v mise >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
    echo "Installing mise..."
    curl -fsSL https://mise.run | sh
fi

# Mark complete (last — so a half-failed run doesn't claim success)
echo "is set up" >> ./already_set_up

cat <<'NOTE'

Setup complete.

  * Tracked dotfiles symlinked into $HOME (originals saved to ~/backup/).
  * mise is installed; run `mise install` to materialize tools pinned in
    .config/mise/config.toml (e.g. rust — this can be slow).
  * Open a new shell to pick up everything.

NOTE
