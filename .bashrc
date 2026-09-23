# ~/.bashrc — backup shell. Mirrors ~/.zshrc as closely as bash allows.
# shellcheck shell=bash
# Kept bash-3.2 compatible so it runs on stock macOS bash.

# Bail out if not interactive
[ -z "$PS1" ] && return

# ------------------------------------------------------------------------------
# History (mirrors zsh HISTSIZE/SAVEHIST)
# ------------------------------------------------------------------------------
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend checkwinsize

# ------------------------------------------------------------------------------
# Vi mode (mirrors zsh `bindkey -v`)
# ------------------------------------------------------------------------------
set -o vi

# ------------------------------------------------------------------------------
# Prompt — colored bracketed style, red-username if root
# ------------------------------------------------------------------------------
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

force_color_prompt=yes
if [ -n "$force_color_prompt" ] && [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=no
fi

BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
BBLUE='\[\033[1;34m\]'
NORMAL='\[\033[00m\]'

if [ "$color_prompt" = yes ]; then
    if [ "$UID" -eq 0 ]; then
        PS1="${BBLUE}[${BRED}\u${GREEN}@\h${BBLUE}] ${BBLUE}[${GREEN}\w${BBLUE}] ${NORMAL}\n# "
    else
        PS1="${BBLUE}[${BGREEN}\u${GREEN}@\h${BBLUE}] ${BBLUE}[${GREEN}\w${BBLUE}] ${NORMAL}\n\$ "
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# xterm title: user@host: dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# ------------------------------------------------------------------------------
# Editor / browser (match zsh)
# ------------------------------------------------------------------------------
export EDITOR="vim"

# ------------------------------------------------------------------------------
# Wumbo
# ------------------------------------------------------------------------------
export wumbo=1

# ==============================================================================
# = paths and tool activations (portable: Linux + macOS) =
# ==============================================================================

# Homebrew (macOS; Apple Silicon or Intel)
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$_brew" ]; then eval "$("$_brew" shellenv)"; break; fi
done
unset _brew

# user bin (mise, pipx, hand-installed tools); skip if a login shell added it
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH

# mise (only if installed)
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

# Cross-platform ls flags (BSD on macOS, GNU on Linux)
if [ "$(uname)" = "Darwin" ]; then
    alias ls="ls -Gh"
else
    alias ls="ls --color=auto -h --group-directories-first"
fi

# Bash completion: Debian system path, else Homebrew's bash-completion@2
if ! shopt -oq posix; then
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
        . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    fi
fi

# Per-host overrides (kept outside the repo)
if [ -f "$HOME/.bashrc.local" ]; then source "$HOME/.bashrc.local"; fi
